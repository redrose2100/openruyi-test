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
# @Desc      :   Test arping command
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
    arping -f "${NODE2_IPV4}" | grep "Received 1 response(s)"
    CHECK_RESULT $? 0 0 "arping -f execute failed"
    arping -qf "${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "arping -qf execute failed"
    arping -b "${NODE2_IPV4}" -c 3 | grep "Received 3 response(s)"
    CHECK_RESULT $? 0 0 "arping -b execute failed"
    arping -D "${NODE2_IPV4}" | grep "Received 1 response(s)"
    CHECK_RESULT $? 0 0 "arping -D execute failed"
    arping -U -s "${NODE1_IPV4}" "${NODE2_IPV4}" -w 5 | grep "Received 5 response(s)"
    CHECK_RESULT $? 0 0 "arping -U execute failed"
    arping -A -s "${NODE1_IPV4}" "${NODE2_IPV4}" -c 3 | grep "Received 0 response(s)"
    CHECK_RESULT $? 0 0 "arping -A execute failed"
    arping -V | grep "arping from iputils"
    CHECK_RESULT $? 0 0 "arping -V execute failed"
    arping -c 3 "${NODE2_IPV4}" | grep "Received 3 response(s)"
    CHECK_RESULT $? 0 0 "arping -c execute failed"
    arping -w 5 "${NODE2_IPV4}" | grep "Received 5 response(s)"
    CHECK_RESULT $? 0 0 "arping -w execute failed"
    arping -i 3 "${NODE2_IPV4}" -c 3 | grep "Received 3 response(s)"
    CHECK_RESULT $? 0 0 "arping -i execute failed"
    arping -I "${NODE1_NIC}" "${NODE2_IPV4}" -c 3 | grep "Received 3 response(s)"
    CHECK_RESULT $? 0 0 "arping -I execute failed"
    arping -s "${NODE1_IPV4}" "${NODE2_IPV4}" -c 3 | grep "Received 3 response(s)"
    CHECK_RESULT $? 0 0 "arping -s execute failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
