#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   验证pscap参数
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which pscap || DNF_INSTALL "libcap-ng libcap-ng-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pscap -a | grep -A5 "capabilities"
    CHECK_RESULT $? 0 0 "Check pscap -a failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@" 
    LOG_INFO "End to restore the test environment."
}

main "$@"