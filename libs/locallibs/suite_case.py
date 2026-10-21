# -*- coding: utf-8 -*-
"""
 Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : lemon-higgins
 @email   : lemon.higgins@aliyun.com
 @Date    : 2021-04-20 19:17:45
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 获取测试套信息
"""

import sys
import os
import json
import re
import argparse

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_PATH)
import mugen_log


def _find_suite_json(suite):
    """在 suite2cases 目录下递归查找 <suite>.json，返回唯一绝对路径。

    支持任意层级分类目录（如 suite2cases/function-test/pkgs-test/acl.json）。
    找到 0 个报错退出；找到多个（重名）报错并列出冲突候选，绝不静默任选。

    Args:
        suite ([str]): 测试套名

    Returns:
        [str]: 测试套 json 绝对路径
    """
    oet_path = os.environ.get("OET_PATH")
    if oet_path is None:
        mugen_log.logging("error", "环境变量：OET_PATH不存在，请检查mugen框架.")
        sys.exit(1)

    suite2cases_dir = os.path.join(oet_path.rstrip("/"), "suite2cases")
    target = "%s.json" % suite
    matches = []
    for root, _, files in os.walk(suite2cases_dir):
        if target in files:
            matches.append(os.path.join(root, target))

    if not matches:
        mugen_log.logging("error", "无法找到测试套的json文件:%s." % suite)
        sys.exit(1)
    if len(matches) > 1:
        mugen_log.logging(
            "error", "套件名冲突:%s 在 suite2cases 下多个目录中存在:" % suite
        )
        for one in matches:
            mugen_log.logging("error", "  %s" % one)
        sys.exit(1)
    return matches[0]


def suite_path(suite):
    """获取测试套路径

    Args:
        suite ([str]): 测试套名

    Returns:
        [str]: 测试套路径
    """
    suite_json = _find_suite_json(suite)

    try:
        with open(suite_json, "r") as f:
            suite_data = json.loads(f.read())
        if suite_data["path"] is None:
            mugen_log.logging("error", "json文件:%s中没有path值." % suite_json)
            sys.exit(1)

        oet = re.match(r'^"?\${?OET_PATH}?"?', suite_data["path"])
        if oet is not None:
            return suite_data["path"].replace(oet.group(), os.environ.get("OET_PATH"))
        else:
            return suite_data["path"]

    except json.decoder.JSONDecodeError as e:
        mugen_log.logging("error", e)
        sys.exit(1)
    except KeyError as e:
        mugen_log.logging("error", "A key:%s error specifying JSON data" % e)
        sys.exit(1)


def suite_cases(suite):
    """获取测试套中用例列表

    Args:
        suite ([str]): 测试套名

    Returns:
        [list]: 用例列表
    """
    suite_json = _find_suite_json(suite)

    try:
        with open(suite_json, "r") as f:
            suite_data = json.loads(f.read())
        if suite_data["cases"] is None:
            mugen_log.logging("error", "json文件:%s中没有cases值." % suite_json)
            sys.exit(1)

        case_list = ""
        for case_data in suite_data["cases"]:
            case_list += case_data["name"] + "\n"
        return case_list.rstrip("\n")

    except json.decoder.JSONDecodeError as e:
        mugen_log.logging("error", e)
        sys.exit(1)
    except KeyError as e:
        mugen_log.logging("error", "A key:%s error specifying JSON data" % e)
        sys.exit(1)

EXCLUDE_DIRS = {".git", "tmp_download", "tmp_extract", "tmp_test", "__pycache__"}

def get_local_dir_files(local_dir):
    """获取本地文件列表

    Args:
        local_dir ([str]): 本地文件所在的目录

    Returns:
        [list]: 文件列表
    """
    all_file = list()

    local_dir = os.path.normpath(local_dir)

    dir_files = os.listdir(local_dir)
    for d_f in dir_files:
        if d_f in EXCLUDE_DIRS:
            continue
        _name = os.path.join(local_dir, d_f)
        if os.path.isdir(_name):
            all_file.extend(get_local_dir_files(_name))
        else:
            all_file.append(_name)

    return all_file

def suite_common(suite):
    """获取测试套中公共文件列表

    Args:
        suite ([str]): 测试套名

    Returns:
        [list]: 公共文件列表
    """
    test_case_list = suite_cases(suite).split("\n")
    test_suite_path = suite_path(suite)

    all_file = get_local_dir_files(test_suite_path)

    common_file = ""
    for one_file in all_file:
        file_name = os.path.basename(one_file)
        suffix_type = file_name.split(".")[-1]
        if suffix_type == "py" or suffix_type == "sh":
            check_file_name = file_name[0:file_name.rfind(".")]
            if check_file_name in test_case_list:
                continue
        rel_path = os.path.relpath(one_file, test_suite_path)
        path_parts = rel_path.split(os.sep)
        if any(part in test_case_list for part in path_parts[:-1]):
            continue
        common_file += one_file + "\n"

    return common_file.rstrip("\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument("--suite", type=str, default=None)
    parser.add_argument("--key", type=str, choices=["path", "cases-name", "common-files"], default=None)
    args = parser.parse_args()

    if args.key == "path":
        print(suite_path(args.suite))
    elif args.key == "cases-name":
        print(suite_cases(args.suite))
    elif args.key == "common-files":
        print(suite_common(args.suite))
    else:
        mugen_log.logging(
            "error", "Other key value fetching is not currently supported."
        )
