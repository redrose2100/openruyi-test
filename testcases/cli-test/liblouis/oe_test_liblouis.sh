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
# @Desc      :   Liblouis command validation
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "liblouis liblouis-devel liblouis-help liblouis-utils python2-louis python3-louis"
    echo '123' > input.txt
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lou_translate --forward en-us-g2.ctb < input.txt | grep 'abc'
    CHECK_RESULT $? 0 0 "Failed to generate ascll braille"
    lou_translate unicode.dis,en-us-g2.ctb < input.txt | grep '⠼⠁⠃⠉'
    CHECK_RESULT $? 0 0 "Failed to generate Unicode Braille"
    echo ",! qk br{n fox" | lou_translate --backward en-us-g2.ctb | grep 'The quick brown fox'
    CHECK_RESULT $? 0 0 "Reverse conversion failed"
    lou_translate -h | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed to view the help manual"
    lou_translate -v | grep 'Liblouis'
    CHECK_RESULT $? 0 0 "Failed to view version information"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf input.txt
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


