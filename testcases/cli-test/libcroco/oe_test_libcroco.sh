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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   libcroco command validation
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libcroco"
    cp tmp.css test.css
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    csslint-0.6 test.css|head -5 | grep 'body {'
    CHECK_RESULT $? 0 0 "Command execution failed"
    sed -i 's/body {/ {/g' test.css
    csslint-0.6 test.css|head -5 | grep 'type {'
    CHECK_RESULT $? 0 0 "The document is not valid"
    csslint-0.6 --dump-location test.css|head -5 | grep 'Parsing location information of the selector'
    CHECK_RESULT $? 0 0 "Command execution failed"
    csslint-0.6 -v | grep '0.6'
    CHECK_RESULT $? 0 0 "Failed to view version information"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.css
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


