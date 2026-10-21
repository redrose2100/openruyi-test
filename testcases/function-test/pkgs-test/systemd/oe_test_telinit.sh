#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   Lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2025-11-24
#@License       :   Mulan PSL v2
#@Desc          :   Test case for telinit command
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "No thing to do"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    
    LOG_INFO "Testing telinit q (reload init configuration)"
    telinit q
    CHECK_RESULT $? 0 0 "telinit q failed to reload init config"
    
    LOG_INFO "Testing telinit Q (uppercase reload init configuration)"
    telinit Q
    CHECK_RESULT $? 0 0 "telinit Q failed to reload init config"
    
    LOG_INFO "Testing telinit u (reexecute init without runlevel change)"
    telinit u
    CHECK_RESULT $? 0 0 "telinit u failed to reexecute init"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "No thing to do"
    LOG_INFO "End to restore the test environment."
}

main "$@"
