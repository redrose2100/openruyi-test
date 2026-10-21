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
    ping -I "${NODE1_IPV4}" "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -I execute failed"
    ping -i 2 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -i execute failed"
    ping -L "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -L execute failed"
    ping -l 2 "${NODE2_IPV4}" -c 3 | grep "received"
    CHECK_RESULT $? 0 0 "ping -l execute failed"
    ping -m 2 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -m execute failed"
    ping -M dont "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -M execute failed"
    ping -n "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -n execute failed"
    ping -O "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -O execute failed"
    ping -p 100 "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -p execute failed"
    ping -q "${NODE2_IPV4}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping -q execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
