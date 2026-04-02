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
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2025/10/13
# @License   :   Mulan PSL v2
# @Desc      :   test apropos
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "man-db"
    mandb > /dev/null 2>&1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run apropos functionality test."
    apropos ls | head -5 | grep -q "ls"
    CHECK_RESULT $? 0 0 "Basic search for 'ls' failed"
    apropos "ls" | grep -q "list"
    CHECK_RESULT $? 0 0 "Search for 'ls' content failed"
    if ls /usr/share/man/man1/printf.1* /usr/share/man/man3/printf.3* >/dev/null 2>&1;then
        apropos "printf" | grep -q "printf"
        CHECK_RESULT $? 0 0 "Search for 'printf' failed"
    fi
    apropos "file" | head -5 | wc -l | grep -q "[1-9]"
    CHECK_RESULT $? 0 0 "Search for 'file' returned no results"
    apropos --help 2>&1 | head -2 | grep -q -E "(usage|apropos)"
    CHECK_RESULT $? 0 0 "Help option test failed"
    apropos --version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Apropos command is not available"
    LOG_INFO "All apropos functionality tests passed successfully."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
