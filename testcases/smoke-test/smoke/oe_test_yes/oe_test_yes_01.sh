#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026-06-12
# @License   :   Mulan PSL v2
# @Desc      :   test yes help/version/default/custom output functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    yes --help | grep -- "--help"
    CHECK_RESULT $? 0 0 "yes help check failed"

    # version
    yes --version | grep "coreutils"
    CHECK_RESULT $? 0 0 "yes version check failed"

    # default output
    yes | head -n 3 > yes_default.txt
    grep -x "y" yes_default.txt
    CHECK_RESULT $? 0 0 "default output failed"

    # custom string
    yes hello | head -n 3 > yes_custom.txt
    grep -c "^hello$" yes_custom.txt | grep "^3$"
    CHECK_RESULT $? 0 0 "custom string output failed"

    # multiple arguments
    yes hello world | head -n 2 > yes_multi.txt
    grep -c "^hello world$" yes_multi.txt | grep "^2$"
    CHECK_RESULT $? 0 0 "multiple arguments output failed"

    # special character
    yes "123-abc" | head -n 1 > yes_special.txt
    grep "^123-abc$" yes_special.txt
    CHECK_RESULT $? 0 0 "special string output failed"

    # invalid option
    yes --invalid-option >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid option should fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."

    rm -rf \
        yes_default.txt \
        yes_custom.txt \
        yes_multi.txt \
        yes_special.txt

    LOG_INFO "Finish environment cleanup!"
}

main "$@"

