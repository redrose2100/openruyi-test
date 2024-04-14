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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2023/05/15
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of b43-tools command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "gcc b43-tools"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    b43-asm -h 2>&1 | grep -F "Usage: b43-asm INPUT_FILE OUTPUT_FILE [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-asm -h failed"

    b43-asm --help 2>&1 | grep -F "Usage: b43-asm INPUT_FILE OUTPUT_FILE [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-asm --help failed"

    b43-dasm -h 2>&1 | grep -F "Usage: b43-dasm INPUT_FILE OUTPUT_FILE [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-dasm -h failed"

    b43-dasm --help 2>&1 | grep -F "Usage: b43-dasm INPUT_FILE OUTPUT_FILE [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-dasm --help failed"

    b43-beautifier -h | grep -F "Usage: b43-beautifier [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"

    b43-beautifier --help | grep -F "Usage: b43-beautifier [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"

    b43-fwdump -h | grep -F "Usage: b43-fwdump [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"

    b43-fwdump --help | grep -F "Usage: b43-fwdump [OPTIONS]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"

    ssb-sprom -h | grep -F "Usage: ssb-sprom [OPTION]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"

    ssb-sprom --help | grep -F "Usage: ssb-sprom [OPTION]"
    CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"

    ssb-sprom -v | grep "Licensed under the GNU/GPL version"
    CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"

    ssb-sprom --version | grep "Licensed under the GNU/GPL version"
    CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restore the test environment."
}

main "$@"
