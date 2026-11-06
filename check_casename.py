#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
 Copyright (c) [2023] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : saarloos
 @email   : 9090-90-90-9090@163.com
 @Date    : 2023-02-06 14:09:36
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 检查mugen测试套，测试名称是否重复(不区分大小写)
"""

import os
import sys
import json
import re

suitecase_path = "suite2cases"
curr_path = os.getcwd()

def check_testsuite():
    # 递归收集 suite2cases 下所有 json 文件（支持分类子目录）
    suitecase_list = []
    for root_dir, _, files in os.walk(os.path.join(curr_path, suitecase_path)):
        for one_file in files:
            if one_file.lower().endswith(".json"):
                suitecase_list.append(os.path.join(root_dir, one_file))

    suitecase_set = {}
    repeat_list = []
    for one_suite in suitecase_list:
        # 只比较文件名（跨目录重名即视为冲突），与 check_suite_cases.py 的唯一性规则一致
        one_name = os.path.basename(one_suite)
        lower_name = one_name.lower()
        if lower_name not in suitecase_set:
            suitecase_set[lower_name] = 1
        else:
            repeat_list.append(one_suite)
            print("%s had repeat from other suitecase name ignore case" % one_suite)
    return len(repeat_list)

def find_case(case_name, check_path):
    find_path = []
    if not os.path.exists(check_path):
        return [-1]

    all_files = os.listdir(check_path)
    for one_file in all_files:
        file_name = os.path.splitext(one_file)[0]
        if os.path.isdir(os.path.join(check_path, one_file)):
            find_path.extend(find_case(case_name, os.path.join(check_path, one_file)))
        else:
            if case_name.lower() == file_name.lower():
                find_path.append(os.path.join(check_path, one_file))
    
    return find_path

def check_one_suite(cases_names, case_path, suitename):
    repeat_case = []
    for one_case in cases_names:
        get_path = find_case(one_case["name"], case_path)
        if len(get_path) > 1:
            repeat_case.append(one_case)
            print("testsuite %s path has repeat case:"%suitename)
            for one_path in get_path:
                print("\trepeat patch name:%s"%one_path)
    return repeat_case

def check_testcase():
    # 递归收集 suite2cases 下所有 json 文件（支持分类子目录）
    suitecase_list = []
    for root_dir, _, files in os.walk(os.path.join(curr_path, suitecase_path)):
        for one_file in files:
            if one_file.lower().endswith(".json"):
                suitecase_list.append(os.path.join(root_dir, one_file))

    ret = 0
    for one_suite in suitecase_list:
        with open(one_suite, "r") as f:
            case_info = json.load(f)
            case_path = os.path.join(curr_path, "/".join(case_info["path"].split("/")[1:]))
            cases_names = case_info["cases"]
            if len(check_one_suite(cases_names, case_path, one_suite)) > 0:
                ret = 1
    return ret          

def check_root_literal():
    """提示用例中硬编码 root@ 的写法。

    用例里直接写 `root@${NODE2_IPV4}` 会假定远端允许 root 登录，非 root
    场景（需要 sudo 提权）下会直接连接失败。这里只做告警，不改变退出码，
    以免既有用例批量变红。

    只匹配“以 root 身份登录远端主机”的写法，刻意排除以下噪音：
      * 邮件地址 / 用户名形式的 root@domain  —— 右侧是域名而非变量或 IP
      * root@localhost、root@127.0.0.1        —— 本机，无需提权
      * grep/regex/expect 模式里的 [root@]   —— 只是在匹配提示符
    """
    # root@ 后面必须是变量引用（$VAR / ${...}）或点分 IP，允许被引号包裹
    target = re.compile(
        r"root@[\"']?(?:\$\{?\w+\}?|\d{1,3}(?:\.\d{1,3}){3})")
    # 落在本机地址上的 root@ 与本场景无关
    local = re.compile(r"root@[\"']?(?:localhost|127\.0\.0\.1)")

    testcase_path = os.path.join(curr_path, "testcases")
    if not os.path.exists(testcase_path):
        return 0

    warns = []
    for root_dir, _, files in os.walk(testcase_path):
        for one_file in sorted(files):
            if not one_file.lower().endswith(".sh"):
                continue
            one_path = os.path.join(root_dir, one_file)
            try:
                with open(one_path, "r", encoding="utf-8", errors="ignore") as f:
                    for lineno, line in enumerate(f, 1):
                        stripped = line.strip()
                        if stripped.startswith("#"):
                            continue
                        hit = target.search(line)
                        if not hit:
                            continue
                        if local.search(line):
                            continue
                        # 单引号内说明是 grep/awk 的匹配模式（如 grep '[root@]'），
                        # 不是真正的连接目标；双引号内的 "${NODE1_IPV4}" 仍算连接。
                        if line.count("'", 0, hit.start()) % 2 == 1:
                            continue
                        warns.append((one_path, lineno, stripped))
            except OSError as exc:
                print("skip %s: %s" % (one_path, exc))

    if warns:
        print("")
        print("WARNING: %d place(s) hardcode 'root@', which breaks non-root "
              "login scenarios." % len(warns))
        print("         Prefer ${NODE<n>_USER}@${NODE<n>_IPV4} so the runner "
              "can escalate via sudo.")
        for one_path, lineno, text in warns:
            rel = os.path.relpath(one_path, curr_path)
            print("  %s:%d: %s" % (rel, lineno, text))
    return len(warns)


def main():
    suite_ret = check_testsuite()
    case_ret = check_testcase()
    # 静态提示，不阻断流水线
    check_root_literal()

    return suite_ret + case_ret
    

if __name__ == "__main__":
    main()
