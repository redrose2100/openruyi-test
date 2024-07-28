#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

##############################################
#@Author    :   zhangshaowei
#@Contact   :   756800989@qq.com
#@Date      :   2022/07/26
#@License   :   Mulan PSL v2
#@Desc      :   Test hwloc-ps
##############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc_version=$(rpm -qa | grep hwloc | grep -oP '\d+\.\d+\.\d+-\d+' | head -n 1)
    hwloc-ps --version | grep "${hwloc_version}"
    CHECK_RESULT $? 0 0 "hwloc-ps --version falied"
    hwloc-ps -h | grep "Usage:"
    CHECK_RESULT $? 1 0 "hwloc-ps -h falied"
    hwloc-ps --help | grep "Usage:"
    CHECK_RESULT $? 1 0 "hwloc-ps --help falied"
    hwloc-ps --uid all -a | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ps --uid all failed"
    hwloc-ps --uid 0 -a | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-ps --uid <uid> falied"
    hwloc-ps -a --short-name | grep 'sshd'
    CHECK_RESULT $? 0 0 "hwloc-ps --short-name  falied"
    hwloc-ps -a -v | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps -v falied"
    hwloc-ps -a --verbose | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps --verbose falied"
    hwloc-ps -a --json-port 8080 | grep 'hwloc-ps'
    CHECK_RESULT $? 0 0 "hwloc-ps --json-port falied"
    hwloc-ps -a --single-ancestor | grep "1"
    CHECK_RESULT $? 0 0 "hwloc-ps --single-ancestor falied"
    hwloc-ps -a --disallowed | grep "bash"
    CHECK_RESULT $? 0 0 "hwloc-ps --disallowed falied"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
