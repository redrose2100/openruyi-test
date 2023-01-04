#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaomingyang
# @Contact   :   gaomingyang@uniontech.com
# @Date      :   2023-01-04
# @License   :   Mulan PSL v2
# @Desc      :   test grep
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    grep -c id /proc/cpuinfo
    CHECK_RESULT $? 0 0 "grep -c fail"	
    grep -n id /proc/cpuinfo
    CHECK_RESULT $? 0 0 "grep -n fail"
    grep -v id /proc/cpuinfo
    CHECK_RESULT $? 0 0 "grep -v fail"
    grep --help | grep "Pattern selection"
    CHECK_RESULT $? 0 0 "grep --help fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "End to clean the test environment."
}

main "$@"






