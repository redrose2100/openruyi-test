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
    ping -4 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -4 execute failed"
    ping -b "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -b execute failed"
    ping -R "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -R execute failed"
    ping -T tsonly "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -T execute failed"
    ping -6 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -6 execute failed"
    ping -F 15 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -F execute failed"
    ping -N name "${NODE2_IPV6}" -c 3 | grep "0 received"
    CHECK_RESULT $? 0 0 "ping -N execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
