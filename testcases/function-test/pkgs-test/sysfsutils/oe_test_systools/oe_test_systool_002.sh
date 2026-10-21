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
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023/12.29
# @License   :   Mulan PSL v2
# @Desc      :   File system common command oe_test_systools
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sysfsutils
    modprobe dm_multipath
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    systool -m dm_multipath -a | grep Attributes
    CHECK_RESULT $? 0 0  "Attributes do not exist"
    systool -m dm_multipath -v | grep Attributes
    CHECK_RESULT $? 0 0  "Attributes do not exist"
    systool -m dm_multipath -p | grep dm_multipath
    CHECK_RESULT $? 0 0  "dm_multipath do not exist"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
