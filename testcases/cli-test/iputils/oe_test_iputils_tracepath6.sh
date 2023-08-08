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
# @Desc      :   Test tracepath6 command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "iputils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tracepath6 -V | grep "tracepath from iputils"
    CHECK_RESULT $? 0 0 "tracepath6 -V execute failed"
    tracepath6 -4 "${NODE2_IPV6}" | grep "tracepath6"
    CHECK_RESULT $? 1 0 "tracepath6 -4 execute failed"
    tracepath6 -6 "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -6 execute failed"
    tracepath6 -b "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -b execute failed"
    tracepath6 -l 65534 "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -l execute failed"
    tracepath6 -m 10 "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -m execute failed"
    tracepath6 -n "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -n execute failed"
    tracepath6 -p 15 "${NODE2_IPV6}" | grep "pmtu"
    CHECK_RESULT $? 0 0 "tracepath6 -p execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
