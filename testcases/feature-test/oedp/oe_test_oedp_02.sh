#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Test oedp repo command 
# #############################################

source "${OET_PATH}/testcases/feature-test/oedp/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL oedp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp repo list 2>&1 | grep -E "openEuler|local"
    CHECK_RESULT $? 0 0 "Failed to list repositories"
    
    oedp repo update
    CHECK_RESULT $? 0 0 "Failed to update repository cache"

    oedp repo set b https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/plugins/ 2>&1 | grep "updated repo: b"
    CHECK_RESULT $? 0 0 "Failed to set repo"

    oedp repo enable b 2>&1 | grep "enabled repo: b"
    CHECK_RESULT $? 0 0 "Failed to enable repo"

    oedp repo disable b 2>&1 | grep "disabled repo: b"
    CHECK_RESULT $? 0 0 "Failed to disable repo"

    oedp repo del b 2>&1 | grep "removed repo: b"
    CHECK_RESULT $? 0 0 "Failed to delete repo"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}


main "$@"
