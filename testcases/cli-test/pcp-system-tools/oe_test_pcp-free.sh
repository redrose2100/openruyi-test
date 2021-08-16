#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-10-27
#@License       :   Mulan PSL v2
#@Desc          :   (pcp-system-tools) (pcp-free)
#####################################

source "common/common_pcp-system-tools.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    /usr/libexec/pcp/bin/pcp-free --help 2>&1 | grep 'Usage'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free --version 2>&1 | grep "$pcp_version"
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -b | grep 'total'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -k | grep 'used'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -m | grep 'free'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -g | grep 'buffers'
    CHECK_RESULT $?
    num=$(/usr/libexec/pcp/bin/pcp-free -o | grep -c 'buffers/cache')
    test 0 -eq $num
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -l | grep 'Low'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-free -t | grep 'Total'
    CHECK_RESULT $?
    num=$(/usr/libexec/pcp/bin/pcp-free -s 2 -c 3 | grep -c 'buffers/cache')
    CHECK_RESULT $?
    test 3 -eq $num
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
