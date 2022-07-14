#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   Jingxu Li
# @Contact   :   jingxu@isrc.iscas.ac.cn
# @Date      :   2022/03/14
# @License   :   Mulan PSL v2
# @Desc      :   Test haproxy
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    LOG_INFO "Nothing to do"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test"
    halog -H < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter HTTP log"
    halog -E < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter no error log"
    halog -e < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter error log"
    halog -rt 1 < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter log time larger than 1"
    halog -Q < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter queued message"
    halog -hs 200 < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter 200 status code"
    halog -Q < haproxy.log | grep "lines"
    CHECK_RESULT $? 0 0 "failed to filter queued message"
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Finish test!"
}

main "$@"
