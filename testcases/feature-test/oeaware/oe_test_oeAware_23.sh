#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl start oeaware
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis -h | grep -F "usage: oeawarectl analysis [options]"
    CHECK_RESULT $? 0 0 "Check analysis -h failed"
    oeawarectl analysis --help | grep -F "usage: oeawarectl analysis [options]"
    CHECK_RESULT $? 0 0 "Check analysis --help failed"
    oeawarectl analysis -t 1 | grep "Summary Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis -t failed"
    oeawarectl analysis -t 100 | grep "Summary Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis -t failed" 
    oeawarectl analysis -t 0 2>&1 | grep "Error: Invalid time value '0' (must be between 1 and 100)"
    CHECK_RESULT $? 0 0 "Check analysis -t failed" 
    oeawarectl analysis -t 101 2>&1 | grep "Error: Invalid time value '101' (must be between 1 and 100)"
    CHECK_RESULT $? 0 0 "Check analysis -t failed" 
    oeawarectl analysis --time  1 | grep "Summary Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis --time failed"
    oeawarectl analysis --time 100 | grep "Summary Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis --time failed"
    oeawarectl analysis --time 0 2>&1 | grep "Error: Invalid time value '0' (must be between 1 and 100)"
    CHECK_RESULT $? 0 0 "Check analysis --time failed"
    oeawarectl analysis --time 101 2>&1 | grep "Error: Invalid time value '101' (must be between 1 and 100)"
    CHECK_RESULT $? 0 0 "Check analysis --time failed"
    oeawarectl analysis -r | grep "Realtime Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis -r failed"
    oeawarectl analysis --realtime | grep "Realtime Analysis Report"
    CHECK_RESULT $? 0 0 "Check analysis --realtime failed" 
    oeawarectl analysis -v | grep "SDK(Analysis) Init result 0"
    CHECK_RESULT $? 0 0 "Check analysis -v failed"
    oeawarectl analysis --verbose | grep "SDK(Analysis) Init result 0"
    CHECK_RESULT $? 0 0 "Check analysis --verbose failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
