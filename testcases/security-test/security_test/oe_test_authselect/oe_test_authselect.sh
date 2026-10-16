#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-1-17
# @License   :   Mulan PSL v2
# @Desc      :   Command authselect
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL authselect
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    authselect list | grep -E "minimal|nis|sssd|winbind"
    CHECK_RESULT $? 0 0 "print config info fail"
    authselect list-features minimal
    CHECK_RESULT $? 0 0 "print effective config info fail"
    authselect test minimal
    CHECK_RESULT $? 0 0 "print the Changes to be written fail"
    authselect show minimal
    CHECK_RESULT $? 0 0 "print config minimal info fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
