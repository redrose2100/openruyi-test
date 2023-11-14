#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-11-13
# @License   :   Mulan PSL v2
# @Desc      :   Command test-augenrules
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=2000 -F auid!=-1 -F key=perm_mod" >> /etc/audit/rules.d/audit.rules
    CHECK_RESULT $? 0 0 "displays one month failure"
    augenrules --load
    CHECK_RESULT $? 0 0 "displays three month failure"
    grep chmod /etc/audit/audit.rules
    CHECK_RESULT $? 0 0  "displays the number of months that failed starting with the month of the date"
    augenrules --check
    CHECK_RESULT $? 0 0  "failed to display date ranges for multiple months"
    augenrules --h|grep Usage
    CHECK_RESULT $? 0 0  "sunday fails as the first day of the week"
  
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i '/chmod/d' /etc/audit/rules.d/audit.rules 
    sed -i '/chmod/d' /etc/audit/audit.rules
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

