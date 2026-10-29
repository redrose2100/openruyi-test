#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
 Copyright (c) [2026] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : redrose2100
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 检查 suite2cases 下 json 文件的格式，以及 json 中声明的用例是否存在对应的 .sh 脚本
"""

import argparse
import json
import os
import re
import subprocess
import sys

SUITE_DIR_NAME = "suite2cases"


def find_repo_root(start_dir):
    """从脚本所在目录向上查找仓库根（含 suite2cases 的目录）。

    脚本位于 .github/scripts 下，不能再用脚本所在目录当仓库根，
    这里改为向上逐级探测，同时兼容被移动到其他层级的情况。
    """
    current = os.path.realpath(start_dir)
    while True:
        if os.path.isdir(os.path.join(current, SUITE_DIR_NAME)):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            break
        current = parent
    # 兜底：退化到脚本上两级目录，保证不会静默拿到错误路径
    return os.path.realpath(os.path.join(start_dir, os.pardir, os.pardir))


# 仓库根目录：以脚本自身位置向上推导，不依赖调用者的当前工作目录
REPO_ROOT = find_repo_root(os.path.dirname(os.path.abspath(__file__)))

# 固定忽略清单：命中的套件文件不做任何校验
# testsuite.json 为团队约定永久跳过，后续所有相关操作均遵循此规则
IGNORE_SUITES = {"testsuite.json"}

# path 字段可能出现两种等价的 OET_PATH 写法，比较前必须先归一化
# 注意顺序：必须先替换带花括号的写法，否则 $OET_PATH 会先命中并残留 {}
OET_PATH_VARS = ("${OET_PATH}", "$OET_PATH")

# 用于提取用例名所在行号，便于在 GitHub 上输出带行号的注解
NAME_LINE_RE = re.compile(r'^\s*"name"\s*:\s*"(.*)"\s*,?\s*$')

# 用例脚本扩展名：按需求只认可 .sh
CASE_EXT = ".sh"

# 检查点 2：CRCRLF（\r\r\n）双 CR 行尾检测。
# 2026-10-21 发现 344 个 .sh 文件以 \r\r\n 入库（git 视为二进制），
# 导致 oe-test 平台上 bash 解析失败（$'\r\r': command not found）全部用例失败。
# 需要扫描的文件类型：shell 脚本与 python 脚本。
LINE_ENDING_EXTENSIONS = (".sh", ".bash", ".py")
# CRCRLF 模式：\r\r\n
CRCRLF_PATTERN = b"\r\r\n"
# 单 CRLF 属于正常行尾（仓库使用 core.autocrlf），不视为问题。
CRLF_PATTERN = b"\r\n"

# 某个套件目录的用例脚本名索引缓存，避免对每个用例重复遍历目录
STEM_CACHE = {}

# 套件目录 -> 「脚本名（小写去扩展名）-> 脚本绝对路径列表」的索引缓存，
# 供运行时字段一致性检查读取脚本内容，避免重复遍历目录
SCRIPT_MAP_CACHE = {}

# 脚本绝对路径 -> 脚本文本的缓存，同一脚本只读一次
SCRIPT_TEXT_CACHE = {}

# 检查点 3/4：套件外层字段与 cases 内层字段的一致性规则常量。
# 语义基准来自 libs/locallibs/check_environment.py：
#   machine num           = case.get('machine num', suite.get('machine num', 1))
#   machine type          = case.get('machine type', suite.get('machine type', 'kvm'))
#   add network interface = case.get('add network interface', suite.get('add network interface', 0))
#   add disk              = len(case.get('add disk', suite.get('add disk', [])))
DEFAULT_MACHINE_NUM = 1
DEFAULT_MACHINE_TYPE = "kvm"
DEFAULT_NETWORK_INTERFACE = 0
REQUIRED_MACHINE_TYPE = "physical"

# 被检查的四个字段名，与 check_environment.py 读取的键保持一致
FIELD_MACHINE_NUM = "machine num"
FIELD_MACHINE_TYPE = "machine type"
FIELD_NETWORK_INTERFACE = "add network interface"
FIELD_ADD_DISK = "add disk"

# 检查点 5/6：脚本实际依赖与声明值的一致性（运行时风险）。
# NODE2_ / NODE3_ ... 表示用例需要多机；TEST_DISK 表示用例需要额外磁盘。
NODE_HIGHER_RE = re.compile(r"\bNODE([2-9])_")
TEST_DISK_RE = re.compile(r"\bTEST_DISK\b")


class SuiteResult(object):
    """单个套件文件（或一次跳过）的校验结果"""

    def __init__(self):
        self.skipped = False
        self.case_count = 0
        self.errors = []
        self.annotations = []


def normalize_case_path(path_value):
    """把 json 中的 path 归一化为仓库内相对路径。

    去掉 $OET_PATH / ${OET_PATH} 前缀，并去掉首尾斜杠。
    """
    result = path_value
    for oet_var in OET_PATH_VARS:
        result = result.replace(oet_var, "")
    return result.strip("/")


def collect_case_stems(dir_path):
    """递归收集目录下所有 .sh 文件名的集合（去扩展名、转小写）。

    用例脚本有两种存放形式：
      1. <name>.sh 直接放在 path 目录下
      2. <name>/<name>.sh 放在与用例同名的子目录下
    因此必须递归查找。每个目录只扫描一次并缓存，避免对每个用例都遍历一遍。
    """
    if dir_path in STEM_CACHE:
        return STEM_CACHE[dir_path]

    stems = set()
    for root_dir, _, files in os.walk(dir_path):
        for one_file in files:
            if os.path.splitext(one_file)[1].lower() != CASE_EXT:
                continue
            stems.add(os.path.splitext(one_file)[0].lower())

    STEM_CACHE[dir_path] = stems
    return stems


def collect_case_scripts(dir_path):
    """递归收集目录下所有 .sh 文件，返回「脚本名（小写去扩展名）-> 绝对路径列表」。

    与 collect_case_stems 使用同一套命名约定，额外保留路径以便读取脚本内容。
    同样按目录缓存，避免重复遍历。
    """
    if dir_path in SCRIPT_MAP_CACHE:
        return SCRIPT_MAP_CACHE[dir_path]

    script_map = {}
    for root_dir, _, files in os.walk(dir_path):
        for one_file in files:
            if os.path.splitext(one_file)[1].lower() != CASE_EXT:
                continue
            stem = os.path.splitext(one_file)[0].lower()
            script_map.setdefault(stem, []).append(os.path.join(root_dir, one_file))

    SCRIPT_MAP_CACHE[dir_path] = script_map
    return script_map


def read_script_text(script_path):
    """读取脚本内容，失败时返回空串（运行时检查属于尽力而为，不因读失败中断）。"""
    if script_path in SCRIPT_TEXT_CACHE:
        return SCRIPT_TEXT_CACHE[script_path]

    try:
        with open(script_path, "r", encoding="utf-8", errors="replace") as handle:
            text = handle.read()
    except OSError:
        text = ""

    SCRIPT_TEXT_CACHE[script_path] = text
    return text


def build_name_line_map(text):
    """扫描文本，建立「用例名 -> 出现行号列表」，用于生成带行号的注解。

    同名用例在同一文件中极少出现，这里仍按列表保存，使用时按顺序弹出。
    """
    name_lines = {}
    for index, line in enumerate(text.splitlines(), 1):
        match = NAME_LINE_RE.match(line)
        if match:
            name_lines.setdefault(match.group(1), []).append(index)
    return name_lines


def take_line(name_lines, case_name):
    """取出某个用例名对应的行号（按出现顺序消费），取不到时返回 0。"""
    lines = name_lines.get(case_name)
    if not lines:
        return 0
    return lines.pop(0)


def peek_line(name_lines, case_name):
    """查看某个用例名对应的行号但不消费，取不到时返回 0。

    同一个用例既要用于字段一致性注解、又要用于脚本存在性注解，
    因此在循环开头统一取一次行号，供后续所有检查复用。
    """
    lines = name_lines.get(case_name)
    if not lines:
        return 0
    return lines[0]


def find_field_line(text, start_line, field_name):
    """从用例名所在行向后查找某字段真正所在的行号。

    用例块的结束以右花括号或下一个左花括号为界；找不到时回退到用例名所在行。
    """
    if start_line <= 0:
        return 0

    field_pattern = re.compile(r'^\s*"%s"\s*:' % re.escape(field_name))
    lines = text.splitlines()
    index = start_line
    while index < len(lines):
        one_line = lines[index]
        if field_pattern.match(one_line):
            return index + 1
        stripped = one_line.strip()
        if stripped.startswith("}") or stripped.startswith("{"):
            break
        index += 1
    return start_line


def as_int(value):
    """把字段值转成 int，非整数返回 None（bool 不算整数）。"""
    if isinstance(value, bool) or not isinstance(value, int):
        return None
    return value


def as_disk_list(value):
    """把 add disk 字段归一化为列表，异常形态返回 None。"""
    if isinstance(value, list):
        return value
    return None


def check_field_consistency(rel_path, text, suite_data, one_case, line_no, result):
    """检查点 3：套件外层字段必须覆盖 cases 内层字段（R1-R4）。

    语义基准：case 内声明优先于套件外层，外层缺失时取默认值。
    外层值必须 >= 内层值，否则要么是多机/网卡被低估（运行时直接退出），
    要么是文档语义不自洽。
    """
    case_name = one_case["name"]

    # R1：machine num 外层必须 >= 每个 case 的 machine num
    case_num = as_int(one_case.get(FIELD_MACHINE_NUM))
    if case_num is not None:
        suite_num = as_int(suite_data.get(FIELD_MACHINE_NUM))
        if suite_num is None:
            suite_num = DEFAULT_MACHINE_NUM
        if case_num > suite_num:
            result.errors.append(
                "%s: case '%s' declares machine num %d, but suite level machine num is %d"
                % (rel_path, case_name, case_num, suite_num)
            )
            result.annotations.append(
                (
                    rel_path,
                    find_field_line(text, line_no, FIELD_MACHINE_NUM),
                    0,
                    "machine num mismatch",
                    "case declares machine num %d, suite level is %d (must be >=)"
                    % (case_num, suite_num),
                )
            )

    # R2：add network interface 外层必须 >= 每个 case 的值
    case_nic = as_int(one_case.get(FIELD_NETWORK_INTERFACE))
    if case_nic is not None:
        suite_nic = as_int(suite_data.get(FIELD_NETWORK_INTERFACE))
        if suite_nic is None:
            suite_nic = DEFAULT_NETWORK_INTERFACE
        if case_nic > suite_nic:
            result.errors.append(
                "%s: case '%s' declares add network interface %d, but suite level value is %d"
                % (rel_path, case_name, case_nic, suite_nic)
            )
            result.annotations.append(
                (
                    rel_path,
                    find_field_line(text, line_no, FIELD_NETWORK_INTERFACE),
                    0,
                    "add network interface mismatch",
                    "case declares %d, suite level is %d (must be >=)" % (case_nic, suite_nic),
                )
            )

    # R3：任一 case 需要 physical 时，外层 machine type 必须是 physical
    case_type = one_case.get(FIELD_MACHINE_TYPE)
    if isinstance(case_type, str) and case_type.strip().lower() == REQUIRED_MACHINE_TYPE:
        suite_type = suite_data.get(FIELD_MACHINE_TYPE, DEFAULT_MACHINE_TYPE)
        if not isinstance(suite_type, str):
            suite_type = DEFAULT_MACHINE_TYPE
        if suite_type.strip().lower() != REQUIRED_MACHINE_TYPE:
            result.errors.append(
                "%s: case '%s' requires machine type 'physical', but suite level machine type is '%s'"
                % (rel_path, case_name, suite_type)
            )
            result.annotations.append(
                (
                    rel_path,
                    find_field_line(text, line_no, FIELD_MACHINE_TYPE),
                    0,
                    "machine type mismatch",
                    "case requires 'physical', suite level is '%s'" % suite_type,
                )
            )

    # R4：case 使用的 add disk 取值必须被外层 add disk 覆盖
    case_disk = as_disk_list(one_case.get(FIELD_ADD_DISK))
    if case_disk is not None:
        suite_disk = as_disk_list(suite_data.get(FIELD_ADD_DISK))
        if suite_disk is None:
            suite_disk = []
        missing_values = []
        for one_value in case_disk:
            if one_value not in suite_disk and one_value not in missing_values:
                missing_values.append(one_value)
        if missing_values:
            result.errors.append(
                "%s: case '%s' uses add disk %s, but suite level add disk is %s"
                % (
                    rel_path,
                    case_name,
                    json.dumps(case_disk, ensure_ascii=False),
                    json.dumps(suite_disk, ensure_ascii=False),
                )
            )
            result.annotations.append(
                (
                    rel_path,
                    find_field_line(text, line_no, FIELD_ADD_DISK),
                    0,
                    "add disk not covered",
                    "case uses %s, suite level covers %s"
                    % (
                        json.dumps(missing_values, ensure_ascii=False),
                        json.dumps(suite_disk, ensure_ascii=False),
                    ),
                )
            )


def find_pattern_line(script_text, pattern):
    """返回脚本中第一处匹配该正则的行号，找不到返回 0。"""
    for index, one_line in enumerate(script_text.splitlines(), 1):
        if pattern.search(one_line):
            return index
    return 0


def check_runtime_requirement(
    rel_path, case_name, line_no, script_paths, effective_num, effective_disk, result
):
    """检查点 4：脚本实际需要的机器数/额外磁盘必须被声明覆盖。

    - R-a：脚本引用 NODE2_ / NODE3_ ... 时，生效的 machine num 必须足够大，
           否则 check_environment.py 会 sys.exit(1)。
    - R-b：脚本引用 TEST_DISK 时，生效的 add disk 列表长度必须 >= 1，
           否则用例拿不到额外磁盘。
    """
    max_node = 0
    node_script = None
    disk_script = None

    for one_script in script_paths:
        script_text = read_script_text(one_script)
        if not script_text:
            continue

        for match in NODE_HIGHER_RE.finditer(script_text):
            one_node = int(match.group(1))
            if one_node > max_node:
                max_node = one_node
                node_script = one_script

        if disk_script is None and TEST_DISK_RE.search(script_text):
            disk_script = one_script

    if node_script is not None and max_node > effective_num:
        script_rel = os.path.relpath(node_script, REPO_ROOT).replace(os.sep, "/")
        script_text = read_script_text(node_script)
        script_line = find_pattern_line(script_text, NODE_HIGHER_RE)
        result.errors.append(
            "%s: case '%s' uses NODE%d_ in %s:%d, but effective machine num is %d"
            % (rel_path, case_name, max_node, script_rel, script_line, effective_num)
        )
        result.annotations.append(
            (
                rel_path,
                line_no,
                0,
                "machine num too small",
                "script %s:%d uses NODE%d_, effective machine num is %d"
                % (script_rel, script_line, max_node, effective_num),
            )
        )

    if disk_script is not None and effective_disk < 1:
        script_rel = os.path.relpath(disk_script, REPO_ROOT).replace(os.sep, "/")
        script_text = read_script_text(disk_script)
        script_line = find_pattern_line(script_text, TEST_DISK_RE)
        result.errors.append(
            "%s: case '%s' uses TEST_DISK in %s:%d, but effective add disk is empty"
            % (rel_path, case_name, script_rel, script_line)
        )
        result.annotations.append(
            (
                rel_path,
                line_no,
                0,
                "add disk missing",
                "script %s:%d uses TEST_DISK, but no add disk is declared"
                % (script_rel, script_line),
            )
        )


def check_one_suite(json_path):
    """校验单个套件 json，返回 SuiteResult。"""
    result = SuiteResult()
    file_name = os.path.basename(json_path)
    rel_path = os.path.relpath(json_path, REPO_ROOT).replace(os.sep, "/")

    # 固定忽略清单：testsuite.json 永久跳过，不校验也不修改
    if file_name in IGNORE_SUITES:
        result.skipped = True
        return result

    try:
        with open(json_path, "r", encoding="utf-8-sig") as handle:
            text = handle.read()
    except OSError as exc:
        result.errors.append("%s: cannot read file: %s" % (rel_path, exc))
        result.annotations.append((rel_path, 0, 0, "read error", str(exc)))
        return result

    try:
        data = json.loads(text)
    except json.JSONDecodeError as exc:
        result.errors.append(
            "%s:%d:%d: invalid JSON: %s" % (rel_path, exc.lineno, exc.colno, exc.msg)
        )
        result.annotations.append((rel_path, exc.lineno, exc.colno, "invalid JSON", exc.msg))
        return result

    if not isinstance(data, dict):
        result.errors.append("%s: top level JSON value must be an object" % rel_path)
        result.annotations.append((rel_path, 0, 0, "invalid structure", "top level must be an object"))
        return result

    if "path" not in data or not isinstance(data.get("path"), str):
        result.errors.append("%s: field 'path' is missing or not a string" % rel_path)
        result.annotations.append((rel_path, 0, 0, "invalid structure", "field 'path' missing or not a string"))
        return result

    if "cases" not in data or not isinstance(data.get("cases"), list):
        result.errors.append("%s: field 'cases' is missing or not an array" % rel_path)
        result.annotations.append((rel_path, 0, 0, "invalid structure", "field 'cases' missing or not an array"))
        return result

    case_path = normalize_case_path(data["path"])
    abs_case_path = os.path.join(REPO_ROOT, case_path)

    if not os.path.isdir(abs_case_path):
        result.errors.append(
            "%s: path directory does not exist: %s" % (rel_path, case_path or data["path"])
        )
        result.annotations.append(
            (rel_path, 0, 0, "path not found", "directory does not exist: %s" % case_path)
        )
        return result

    name_lines = build_name_line_map(text)
    stems = collect_case_stems(abs_case_path)
    script_map = collect_case_scripts(abs_case_path)

    # 套件外层字段（缺失时由 check_environment.py 的默认值兜底）
    suite_machine_num = as_int(data.get(FIELD_MACHINE_NUM))
    if suite_machine_num is None:
        suite_machine_num = DEFAULT_MACHINE_NUM
    suite_network_interface = as_int(data.get(FIELD_NETWORK_INTERFACE))
    if suite_network_interface is None:
        suite_network_interface = DEFAULT_NETWORK_INTERFACE
    suite_add_disk = as_disk_list(data.get(FIELD_ADD_DISK))
    if suite_add_disk is None:
        suite_add_disk = []

    seen_names = set()
    for one_case in data["cases"]:
        if not isinstance(one_case, dict) or not isinstance(one_case.get("name"), str):
            result.errors.append("%s: case entry is not an object with a string 'name'" % rel_path)
            result.annotations.append(
                (rel_path, 0, 0, "invalid structure", "case entry missing string 'name'")
            )
            continue

        case_name = one_case["name"]
        result.case_count += 1

        # 单个 json 内 case name 不允许重复（大小写不敏感，与既有约定保持一致）
        case_key = case_name.lower()
        if case_key in seen_names:
            line_no = take_line(name_lines, case_name)
            result.errors.append(
                "%s: duplicate case name '%s' in the same suite" % (rel_path, case_name)
            )
            result.annotations.append(
                (rel_path, line_no, 0, "duplicate case name", "case name '%s' appears more than once" % case_name)
            )
            continue
        seen_names.add(case_key)

        # 检查点 3：外层字段必须覆盖 case 内层字段（R1-R4），
        # 只依赖 json 内容，与脚本是否存在无关，因此先于脚本存在性检查执行。
        case_line_no = peek_line(name_lines, case_name)
        check_field_consistency(
            rel_path, text, data, one_case, case_line_no, result
        )

        if case_name.lower() not in stems:
            line_no = take_line(name_lines, case_name)
            result.errors.append(
                "%s: case '%s' has no matching %s under %s"
                % (rel_path, case_name, CASE_EXT, case_path)
            )
            result.annotations.append(
                (
                    rel_path,
                    line_no,
                    0,
                    "missing case script",
                    "case '%s' has no matching %s under %s" % (case_name, CASE_EXT, case_path),
                )
            )
            continue

        # 检查点 4：脚本实际依赖必须被声明覆盖（R-a 多机 / R-b 额外磁盘）
        case_script_paths = script_map.get(case_name.lower(), [])
        effective_num = as_int(one_case.get(FIELD_MACHINE_NUM))
        if effective_num is None:
            effective_num = suite_machine_num
        effective_disk = as_disk_list(one_case.get(FIELD_ADD_DISK))
        if effective_disk is None:
            effective_disk = suite_add_disk
        check_runtime_requirement(
            rel_path,
            case_name,
            case_line_no,
            case_script_paths,
            effective_num,
            len(effective_disk),
            result,
        )

    return result


def list_all_suites():
    """列出 suite2cases 下（含子目录）所有 json 文件。"""
    suite_dir = os.path.join(REPO_ROOT, SUITE_DIR_NAME)
    if not os.path.isdir(suite_dir):
        return []
    names = []
    for root_dir, _, files in os.walk(suite_dir):
        for one in files:
            if one.lower().endswith(".json"):
                names.append(os.path.join(root_dir, one))
    return sorted(names)


def is_root_level_suite(rel_path):
    """判断 suite2cases 下的 json 是否直接放在根目录（无分类子目录）。

    检查点 1：suite2cases 根目录不允许直接放置 json 文件，
    所有 json 必须位于子目录中。testsuite.json 为团队约定永久豁免。

    Args:
        rel_path ([str]): 相对仓库根的路径（使用 / 分隔）

    Returns:
        [bool]: True 表示该 json 违反检查点 1
    """
    if os.path.basename(rel_path) in IGNORE_SUITES:
        return False
    rest = rel_path[len(SUITE_DIR_NAME) + 1:]
    return "/" not in rest


def check_root_json_placement():
    """全量扫描 suite2cases 根目录，检查是否有直接放置的 json 文件。

    检查点 1：所有 json 必须位于 suite2cases 的子目录中，
    根目录只允许 testsuite.json（永久豁免）。

    Returns:
        [list]: 错误列表，无违规时为空列表
    """
    suite_dir = os.path.join(REPO_ROOT, SUITE_DIR_NAME)
    if not os.path.isdir(suite_dir):
        return []

    errors = []
    for one in sorted(os.listdir(suite_dir)):
        abs_path = os.path.join(suite_dir, one)
        if not os.path.isfile(abs_path):
            continue
        if not one.lower().endswith(".json"):
            continue
        if one in IGNORE_SUITES:
            continue
        rel_path = os.path.relpath(abs_path, REPO_ROOT).replace(os.sep, "/")
        errors.append(
            "%s: json file must be placed in a subdirectory of %s, not directly under it"
            % (rel_path, SUITE_DIR_NAME)
        )
    return errors


def check_suite_name_uniqueness():
    """全量扫描 suite2cases（含子目录），检查套件 json 文件名是否重名。

    规则：
      - 忽略固定清单中的文件（testsuite.json 等）
      - 大小写不敏感去重（与 check_casename.py 的既有约定保持一致，
        避免在 Linux 大小写敏感文件系统与 Windows 大小写不敏感文件系统之间漂移）
      - 返回错误列表（每条含套件名与冲突路径），无冲突时返回空列表
    """
    suite_dir = os.path.join(REPO_ROOT, SUITE_DIR_NAME)
    if not os.path.isdir(suite_dir):
        return []

    by_name = {}
    for root_dir, _, files in os.walk(suite_dir):
        for one_file in files:
            if not one_file.lower().endswith(".json"):
                continue
            if one_file in IGNORE_SUITES:
                continue
            key = one_file[: -len(".json")].lower()
            by_name.setdefault(key, []).append(
                os.path.join(root_dir, one_file)
            )

    errors = []
    for key, paths in sorted(by_name.items()):
        if len(paths) < 2:
            continue
        rel_paths = [
            os.path.relpath(one, REPO_ROOT).replace(os.sep, "/") for one in paths
        ]
        errors.append(
            "duplicate suite name '%s' (%s): %s"
            % (key, ".json", ", ".join(rel_paths))
        )
    return errors


def check_crcrlf_line_endings(targets):
    """检查文件是否包含 CRCRLF（\\r\\r\\n）双 CR 行尾（检查点 2）。

    2026-10-21 仓库内 344 个 .sh 文件以 \\r\\r\\n 行尾入库，git 将其识别为二进制
    （i/-text），在测试平台上 bash 解析失败导致大量用例失败。此检查确保
    之后不会再混入此类文件。

    Args:
        targets ([list]): 绝对路径列表（.sh/.bash/.py）

    Returns:
        [list]: (rel_path, error_message, line_no) 元组列表
    """
    results = []
    for one_target in targets:
        if os.path.splitext(one_target)[1].lower() not in LINE_ENDING_EXTENSIONS:
            continue
        if not os.path.isfile(one_target):
            continue
        try:
            with open(one_target, "rb") as handle:
                data = handle.read()
        except OSError:
            continue
        crcrlf_count = data.count(CRCRLF_PATTERN)
        if crcrlf_count == 0:
            continue
        rel_path = os.path.relpath(one_target, REPO_ROOT).replace(os.sep, "/")
        # 统计哪些行是双 CR 行尾（用于行号标注）
        bad_lines = []
        line_no = 0
        pos = 0
        while pos < len(data):
            line_no += 1
            nl = data.find(b"\n", pos)
            if nl == -1:
                nl = len(data)
            if data[pos:nl].endswith(b"\r\r"):
                bad_lines.append(line_no)
            pos = nl + 1
        first_bad = bad_lines[0] if bad_lines else 1
        line_desc = ""
        if bad_lines:
            shown = bad_lines[:5]
            line_desc = " (lines: %s%s)" % (
                ", ".join(str(x) for x in shown),
                "..." if len(bad_lines) > 5 else "",
            )
        results.append(
            (
                rel_path,
                "file contains CRCRLF (double-CR) line endings: %d occurrence(s)%s; "
                "normalize to LF (or single CRLF) before committing"
                % (crcrlf_count, line_desc),
                first_bad,
            )
        )
    return results


def resolve_input_files(raw_files):
    """把 --files 入参规范化为绝对路径，并只保留 suite2cases 子树下的 json 文件。"""
    suite_dir = os.path.realpath(os.path.join(REPO_ROOT, SUITE_DIR_NAME))
    resolved = []
    for one_file in raw_files:
        abs_path = os.path.realpath(os.path.abspath(one_file))
        if not abs_path.lower().endswith(".json"):
            continue
        if os.path.commonpath([abs_path, suite_dir]) != suite_dir:
            continue
        resolved.append(abs_path)
    return sorted(set(resolved))


def resolve_script_files(raw_files):
    """把 --files 入参规范化为绝对路径，并只保留脚本文件（.sh/.bash/.py）。"""
    resolved = []
    for one_file in raw_files:
        abs_path = os.path.realpath(os.path.abspath(one_file))
        if os.path.splitext(abs_path)[1].lower() not in LINE_ENDING_EXTENSIONS:
            continue
        resolved.append(abs_path)
    return sorted(set(resolved))


def list_all_scripts():
    """列出仓库内所有脚本文件（.sh/.bash/.py），用于全量 CRCRLF 检查。"""
    names = []
    for root_dir, _, files in os.walk(REPO_ROOT):
        if ".git" in root_dir:
            continue
        for one in files:
            if os.path.splitext(one)[1].lower() in LINE_ENDING_EXTENSIONS:
                names.append(os.path.join(root_dir, one))
    return sorted(names)


def list_changed_scripts(changed_from, changed_to):
    """用 git diff 列出变动文件，并只保留脚本文件（.sh/.bash/.py）。"""
    cmd = [
        "git",
        "-C",
        REPO_ROOT,
        "diff",
        "--name-only",
        "--diff-filter=ACMR",
        changed_from,
    ]
    if changed_to:
        cmd.append(changed_to)

    try:
        completed = subprocess.run(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False
        )
    except OSError as exc:
        sys.stderr.write("ERROR: cannot run git: %s\n" % exc)
        sys.exit(2)

    if completed.returncode != 0:
        sys.stderr.write("ERROR: git diff failed for '%s':\n%s\n"
                         % (changed_from, completed.stderr.decode("utf-8", "replace")))
        sys.exit(2)

    changed = completed.stdout.decode("utf-8", "replace").splitlines()
    resolved = []
    for one_file in changed:
        one_file = one_file.strip()
        if os.path.splitext(one_file)[1].lower() not in LINE_ENDING_EXTENSIONS:
            continue
        resolved.append(os.path.join(REPO_ROOT, one_file.replace("/", os.sep)))
    return sorted(set(resolved))


def list_changed_suites(changed_from, changed_to):
    """用 git diff 列出变动文件，并过滤出 suite2cases 下的 json。"""
    cmd = [
        "git",
        "-C",
        REPO_ROOT,
        "diff",
        "--name-only",
        "--diff-filter=ACMR",
        changed_from,
    ]
    if changed_to:
        cmd.append(changed_to)

    try:
        completed = subprocess.run(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False
        )
    except OSError as exc:
        sys.stderr.write("ERROR: cannot run git: %s\n" % exc)
        sys.exit(2)

    if completed.returncode != 0:
        sys.stderr.write("ERROR: git diff failed for '%s':\n%s\n"
                         % (changed_from, completed.stderr.decode("utf-8", "replace")))
        sys.exit(2)

    changed = completed.stdout.decode("utf-8", "replace").splitlines()
    suite_dir = os.path.join(REPO_ROOT, SUITE_DIR_NAME)
    resolved = []
    for one_file in changed:
        one_file = one_file.strip()
        if not one_file.startswith(SUITE_DIR_NAME + "/"):
            continue
        if not one_file.lower().endswith(".json"):
            continue
        resolved.append(os.path.join(REPO_ROOT, one_file.replace("/", os.sep)))
    return sorted(set(resolved))


def emit_annotations(annotations):
    """输出 GitHub Actions 注解，错误会直接标在 PR diff 对应行上。"""
    for rel_path, line_no, col_no, title, message in annotations:
        location = "file=%s" % rel_path
        if line_no:
            location += ",line=%d" % line_no
        if col_no:
            location += ",col=%d" % col_no
        location += ",title=%s" % title
        print("::error %s::%s" % (location, message))


def build_arg_parser():
    parser = argparse.ArgumentParser(
        description="Validate suite2cases JSON files and their case scripts."
    )
    scope = parser.add_mutually_exclusive_group(required=True)
    scope.add_argument("--all", action="store_true", help="check every suite2cases json")
    scope.add_argument("--files", nargs="+", metavar="JSON", help="check the given json files")
    scope.add_argument(
        "--changed-from",
        metavar="REF",
        help="check suite2cases json changed since REF (uses git diff)",
    )
    parser.add_argument(
        "--changed-to",
        metavar="REF",
        help="used with --changed-from to diff two refs instead of REF..worktree",
    )
    parser.add_argument(
        "--github-annotations",
        dest="annotations",
        action="store_true",
        default=None,
        help="force GitHub Actions annotations",
    )
    parser.add_argument(
        "--no-github-annotations",
        dest="annotations",
        action="store_false",
        help="disable GitHub Actions annotations",
    )
    return parser


def main(argv=None):
    args = build_arg_parser().parse_args(argv)

    if args.annotations is None:
        annotations_enabled = os.environ.get("GITHUB_ACTIONS", "").lower() == "true"
    else:
        annotations_enabled = args.annotations

    # 检查点 2 的脚本目标：--files 模式下同时检查传入的脚本文件；
    # --all 模式检查全仓脚本；--changed-from 模式检查变动的脚本。
    script_targets = []
    if args.all:
        targets = list_all_suites()
        scope_desc = "all suite2cases json"
        # 全量模式下顺带做套件名唯一性检查（重名会在运行时导致 mugen 无法定位）
        uniqueness_errors = check_suite_name_uniqueness()
        # 检查点 1：suite2cases 根目录不允许直接放置 json
        root_placement_errors = check_root_json_placement()
        # 检查点 2：全量扫描仓库内脚本文件
        script_targets = list_all_scripts()
    elif args.files:
        targets = resolve_input_files(args.files)
        scope_desc = "given files"
        uniqueness_errors = []
        root_placement_errors = []
        # 检查点 2：--files 中传入的脚本文件（与 json 无关，独立校验）
        script_targets = resolve_script_files(args.files)
    else:
        targets = list_changed_suites(args.changed_from, args.changed_to)
        scope_desc = "changed files since %s" % args.changed_from
        uniqueness_errors = []
        root_placement_errors = []
        # 检查点 2：git diff 中变动的脚本文件
        script_targets = list_changed_scripts(args.changed_from, args.changed_to)

    # 检查点 1：files / changed 模式下，命中 suite2cases 根目录的 json 直接报错，
    # 不进入后续逐套件校验（testsuite.json 永久豁免）。
    if not args.all:
        filtered_targets = []
        for one_target in targets:
            rel_path = os.path.relpath(one_target, REPO_ROOT).replace(os.sep, "/")
            if is_root_level_suite(rel_path):
                root_placement_errors.append(
                    "%s: json file must be placed in a subdirectory of %s, not directly under it"
                    % (rel_path, SUITE_DIR_NAME)
                )
            else:
                filtered_targets.append(one_target)
        targets = filtered_targets

    # 检查点 2：CRCRLF 双 CR 行尾检测
    crcrlf_errors = check_crcrlf_line_endings(script_targets)

    if (
        not targets
        and not uniqueness_errors
        and not root_placement_errors
        and not crcrlf_errors
    ):
        print("No suite2cases json to check (%s), skip." % scope_desc)
        return 0

    total_cases = 0
    checked_suites = 0
    skipped_suites = 0
    all_errors = []
    all_annotations = []

    for one_target in targets:
        result = check_one_suite(one_target)
        if result.skipped:
            skipped_suites += 1
            continue
        checked_suites += 1
        total_cases += result.case_count
        all_errors.extend(result.errors)
        all_annotations.extend(result.annotations)

    for one_error in all_errors:
        print("ERROR %s" % one_error)

    for one_error in uniqueness_errors:
        print("ERROR %s" % one_error)

    for one_error in root_placement_errors:
        print("ERROR %s" % one_error)

    for rel_path, one_error, bad_line in crcrlf_errors:
        print("ERROR %s" % one_error)
        all_annotations.append(
            (
                rel_path,
                bad_line,
                0,
                "CRCRLF line endings",
                "double-CR line endings break bash parsing; normalize to LF",
            )
        )

    if annotations_enabled and all_annotations:
        emit_annotations(all_annotations)

    total_errors = (
        len(all_errors)
        + len(uniqueness_errors)
        + len(root_placement_errors)
        + len(crcrlf_errors)
    )
    print(
        "checked %d suite(s), %d case(s); skipped %d suite(s); %d error(s)"
        % (checked_suites, total_cases, skipped_suites, total_errors)
    )

    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
