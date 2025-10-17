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
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com 
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Test oedp version and help
# #############################################

source "${OET_PATH}/testcases/feature-test/oedp/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_oedp
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."

    oedp --version | grep -E "[0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "Failed to get oedp version or version format incorrect"
    
    oedp -v | grep -E "[0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "Failed to get oedp version with short option or version format incorrect"

    oedp --help | grep "usage: oedp"
    CHECK_RESULT $? 0 0 "Failed to get oedp help"

    oedp -h | grep -E "usage: oedp"
    CHECK_RESULT $? 0 0 "Failed to get oedp help"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    post_oedp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
