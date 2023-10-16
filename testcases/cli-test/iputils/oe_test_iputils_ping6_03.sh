#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023/07/19
# @License   :   Mulan PSL v2
# @Desc      :   Test ping6 command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "iputils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ping6 -Q 10 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -Q execute failed"
    ping6 -s 10 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -s execute failed"
    ping6 -S 20 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -S execute failed"
    ping6 -t 5 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -t execute failed"
    ping6 -U "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -U execute failed"
    ping6 -v "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -v execute failed"
    ping6 -V "${NODE2_IPV6}" -c 3 | grep "ping from iputils"
    CHECK_RESULT $? 0 0 "ping6 -V execute failed"
    ping6 -w 5 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -w execute failed"
    ping6 -W 5 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -W execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
