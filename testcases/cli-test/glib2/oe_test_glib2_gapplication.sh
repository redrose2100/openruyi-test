#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gapplication command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL glib2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gapplication help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gapplication help check failed"
    
    gapplication version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "gapplication version check failed"
    
    timeout 5 gapplication list-apps
    CHECK_RESULT $? 0 0 "gapplication list-apps check failed"
    
    gapplication help launch | grep -i "launch"
    CHECK_RESULT $? 0 0 "gapplication help launch check failed"
    
    gapplication help action | grep -i "action"
    CHECK_RESULT $? 0 0 "gapplication help action check failed"
    
    gapplication help list-actions | grep -i "list-actions"
    CHECK_RESULT $? 0 0 "gapplication help list-actions check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
