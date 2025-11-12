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

 @Author  : zhujinlong
 @email   : zhujinlong@163.com
 @Date    : 2023-10-18 10:00:00
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 获取并检查执行测试用例所需要的环境信息
"""

import argparse
import json
import subprocess
import read_conf
import get_test_device
import mugen_log
import sys


def get_suitejson_info_and_check(suite_file, case):
    """获取并检查执行测试用例所需要的环境信息

    Args:
        suite_file ([str]): 测试套json文件
        case ([str]): 测试用例名

    Returns:
    """
    # 读取测试套json文件
    with open(suite_file, 'r', encoding='utf-8') as f:
        suite_datas = json.load(f)

    # 获取执行测试用例所需要的环境信息
    for case_datas in suite_datas['cases']:
        if case_datas["name"] == case:
            machine_num_required = case_datas.get('machine num', suite_datas.get('machine num', 1))
            machine_type_required = case_datas.get('machine type', suite_datas.get('machine type', 'kvm'))
            network_interface_num_required_add = case_datas.get('add network interface', suite_datas.get('add network interface', 0))
            disk_num_required_add = len(case_datas.get('add disk', suite_datas.get('add disk', [])))
            break
    else:
        raise Exception("testcase not found")

    # 获取当前机器的环境信息
    machine_num = read_conf.node_num()
    machine_type = read_conf.node_type()
    network_interface_name = get_test_device.get_test_nic(1)
    network_interface_num = subprocess.getoutput(
        "echo " + network_interface_name + " | awk '{print NF}'"
    )
    disk_name = get_test_device.get_test_disk(1)
    disk_num = len(disk_name.split())

    # 校验当前环境是否满足执行测试用例的条件
    if int(machine_num) < machine_num_required:
        mugen_log.logging(
            "error", "The number of machines don't meet the requirements for executing the testcase.")
        sys.exit(1)
    elif machine_type == "kvm" and machine_type_required == "physical":
        mugen_log.logging(
            "error", "The type of machines don't meet the requirements for executing the testcase.")
        sys.exit(1)
    elif int(network_interface_num) < network_interface_num_required_add:
        mugen_log.logging(
            "error", "The number of network interface don't meet the requirements for executing the testcase.")
        sys.exit(1)
    elif int(disk_num) < disk_num_required_add:
        mugen_log.logging(
            "error", "The number of disk don't meet the requirements for executing the testcase.")
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument("--suite_file", type=str)
    parser.add_argument("--case", type=str)
    args = parser.parse_args()

    get_suitejson_info_and_check(args.suite_file, args.case)
