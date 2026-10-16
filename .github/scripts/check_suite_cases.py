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

# 某个套件目录的用例脚本名索引缓存，避免对每个用例重复遍历目录
STEM_CACHE = {}


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

        # 不区分大小写匹配，与 check_casename.py 的既有约定保持一致
        if case_name.lower() in stems:
            continue

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

    if args.all:
        targets = list_all_suites()
        scope_desc = "all suite2cases json"
        # 全量模式下顺带做套件名唯一性检查（重名会在运行时导致 mugen 无法定位）
        uniqueness_errors = check_suite_name_uniqueness()
    elif args.files:
        targets = resolve_input_files(args.files)
        scope_desc = "given files"
        uniqueness_errors = []
    else:
        targets = list_changed_suites(args.changed_from, args.changed_to)
        scope_desc = "changed files since %s" % args.changed_from
        uniqueness_errors = []

    if not targets and not uniqueness_errors:
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

    if annotations_enabled and all_annotations:
        emit_annotations(all_annotations)

    total_errors = len(all_errors) + len(uniqueness_errors)
    print(
        "checked %d suite(s), %d case(s); skipped %d suite(s); %d error(s)"
        % (checked_suites, total_cases, skipped_suites, total_errors)
    )

    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
