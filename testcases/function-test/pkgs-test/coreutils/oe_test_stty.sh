#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2026-02-09
#@License       :   Mulan PSL v2
#@Desc          :   Test case for stty command
#####################################
# shellcheck disable=SC1090,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL coreutils
    orig_settings=$(stty -g)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test help output
    stty --help
    CHECK_RESULT $? 0 0 "Help output test failed"

    # Test print all settings
    stty -a
    CHECK_RESULT $? 0 0 "Print all settings failed"

    # Test save settings
    saved_settings=$(stty -g)
    [ -n "$saved_settings" ]
    CHECK_RESULT $? 0 0 "Save settings output empty"

    # Test change setting and verify
    stty -echo
    stty -a | grep -q '\-echo'
    CHECK_RESULT $? 0 0 "Disable echo failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    stty "$orig_settings"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
