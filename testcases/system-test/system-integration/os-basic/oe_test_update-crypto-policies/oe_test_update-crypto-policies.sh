#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.8.13
# @License   :   Mulan PSL v2
# @Desc      :   update-crypto-policies formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "crypto-policies-scripts"    
    update-crypto-policies --set DEFAULT
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    update-crypto-policies --show |grep DEFAULT
    CHECK_RESULT $? 0 0 "update-crypto-policies error"
    update-crypto-policies --set LEGACY
    CHECK_RESULT $? 0 0 "update-crypto-policies error"
    update-crypto-policies --show |grep LEGACY
    CHECK_RESULT $? 0 0 "update-crypto-policies error"
    update-crypto-policies --is-applied
    CHECK_RESULT $? 0 0 "Crypto policy is not applied"
    update-crypto-policies --check
    CHECK_RESULT $? 0 0 "Crypto policy files do not match"
    update-crypto-policies --set LEGACY --no-reload
    CHECK_RESULT $? 0 0 "update-crypto-policies set LEGACY with no-reload failed"
    update-crypto-policies --help | grep -i usage
    CHECK_RESULT $? 0 0 "update-crypto-policies help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    update-crypto-policies --set DEFAULT
    DNF_REMOVE "$@"    
    LOG_INFO "End to restore the test environment."
}

main "$@"
