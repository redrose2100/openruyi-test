#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024.5.30
# @License   :   Mulan PSL v2
# @Desc      :   test utshell typeset direction.
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    utshell -c "typeset -x"
    CHECK_RESULT $? 0 0 "typeset failed."

    utshell -c "typeset -p abcdefg"
    CHECK_RESULT $? 0 1 "typeset -p unknown string success unexpectedly."

    utshell -c "typeset -p"
    CHECK_RESULT $? 0 0 "typeset -p failed."

    utshell -c "typeset -n abcdefg=ls && typeset -p abcdefg"
    CHECK_RESULT $? 0 0 "typeset -n failed."

    utshell -c "typeset -t LANG && typeset -p LANG" | grep -q "declare -tx"
    CHECK_RESULT $? 0 0 "typeset -t failed."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
