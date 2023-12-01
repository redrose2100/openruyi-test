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
# @Desc      :   Test ping command
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
    ping -Q 10 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -Q execute failed"
    ping -s 10 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -s execute failed"
    ping -S 20 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -S execute failed"
    ping -t 5 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -t execute failed"
    ping -U "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -U execute failed"
    ping -v "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -v execute failed"
    ping -V "${NODE2_IPV4}" -c 3 | grep "ping from iputils"
    CHECK_RESULT $? 0 0 "ping -V execute failed"
    ping -w 5 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -w execute failed"
    ping -W 5 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -W execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
