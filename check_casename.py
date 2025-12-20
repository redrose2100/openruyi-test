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

suitecase_path = "suite2cases"
curr_path = os.getcwd()
case_files = {}


def check_testsuite():
    case_path = os.path.join(curr_path, suitecase_path)
    suitecase_list = os.listdir(case_path)
    suitecase_set = {}
    repeat_list = []
    for one_suite in suitecase_list:
        lower_name = one_suite.lower()
        if lower_name not in suitecase_set:
            suitecase_set[lower_name] = 1
        else:
            repeat_list.append(one_suite)
            print("%s/%s had repeat from other suitecase name ignore case" %
                  (case_path, one_suite))
    return len(repeat_list)


def find_case(case_name, all_files):
    find_path = []
    count = 0

    for one_file in all_files:
        file_name = os.path.split(one_file)[1]
        file_name = os.path.splitext(file_name)[0]
        if case_name.lower() == file_name.lower():
            count += 1
    return count


def check_one_suite(case_info, suitename, all_files):
    """检查一个测试套件
    Args:
        case_info cases的json对象
        suitname (str)测试套件名称
        all_files ([list]) 测试套件下所有文件列表       
    """
    repeat_case = []

    for one_case in case_info["cases"]:
        get_count = find_case(one_case["name"], all_files)
        if get_count > 1:
            repeat_case.append(one_case)
            print("testsuite %s path has repeat case:" % suitename,
                  one_case["name"])
            print("\trepeat patch name:%s" % case_info["path"])
    return repeat_case


def get_all_files(local_dir):
    """获取文件列表

    Args:
        local_dir ([str]): 本地目录

    Returns:
        [list]: 文件列表
    """
    all_file = list()

    local_dir = os.path.normpath(local_dir)

    dir_files = os.listdir(local_dir)
    for d_f in dir_files:
        _name = os.path.join(local_dir, d_f)
        if os.path.isdir(_name):
            all_file.extend(get_all_files(_name))
        else:
            all_file.append(_name)

    return all_file


# 获得当前路径的所有文件
def get_case_files(case_path):
    #找到目录下所有文件，加入case_files字典中
    if case_path not in case_files:
        case_files[case_path] = get_all_files(case_path)
    return case_files[case_path]


def check_testcase():
    suitecase_list = get_all_files(os.path.join(curr_path, suitecase_path))
    ret = 0
    for one_suite in suitecase_list:
        with open(os.path.join(curr_path, suitecase_path, one_suite),
                  "r") as f:
            case_info = json.load(f)
            # 在testcase的下查询所有子目录是否有重复测试用例
            # 避免类似 $OET_PATH/testcases/security_test 处理后只有testcase目录
            s_path = case_info["path"].split("/")
            if len(s_path) > 3:
                case_path = "/".join(s_path[1:-1])
            else:
                case_path = "/".join(s_path[1:])
            files = get_case_files(case_path)
            if len(check_one_suite(case_info, one_suite, files)) > 0:
                ret = 1
    return ret


def main():
    suite_ret = check_testsuite()
    case_ret = check_testcase()

    return suite_ret + case_ret


if __name__ == "__main__":
    main()
