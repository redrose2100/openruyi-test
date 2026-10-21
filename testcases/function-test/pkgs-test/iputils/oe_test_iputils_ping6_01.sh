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
    DNF_INSTALL "iputils dmidecode"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ping6 -a "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -a execute failed"
    ping6 -A "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -A execute failed"
    ping6 -B "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -B execute failed"
    ping6 "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -c execute failed"
    ping6 -D "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -D execute failed"
    ping6 -d "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -d execute failed"
    if dmidecode -s system-product-name | grep Virtual; then
        ping6 -C "${NODE2_IPV6}" -c 3 | grep "3 received"
        CHECK_RESULT $? 0 0 "ping6 -C execute failed"
        ping6 -e 10 "${NODE2_IPV6}" -c 3 | grep "3 received"
        CHECK_RESULT $? 0 0 "ping6 -e execute failed"
    fi
    ping6 -f "${NODE2_IPV6}" -c 3 | grep "3 received"
    CHECK_RESULT $? 0 0 "ping6 -f execute failed"
    ping6 -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "ping6 -h execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
