#! /usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-03-19
# @License   :   Mulan PSL v2
# @Desc      :   Command test-aulast
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    aulast|grep root
    CHECK_RESULT $? 0 0 "failed to print the user login list. Procedure"
    aulast --extract
    CHECK_RESULT $? 0 0 "description failed to generate log files"
    test -f aulast.log
    CHECK_RESULT $? 0 0 "file does not exist"
    aulast -f aulast.log
    CHECK_RESULT $? 0 0 "failed to enter using the file"
    aulast --user root
    CHECK_RESULT $? 0 0 "only the root user fails to be displayed"
    aulast --tty tty1
    CHECK_RESULT $? 0 0 "failed to filter tty login users. Procedure"
    aulast --proof|grep ausearch
    CHECK_RESULT $? 0 0 "failed to print the audit event sequence number used to determine a row on the report"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm -rf aulast.log
    export LANG=${OLD_LANG}
    LOG_INFO "End to clean the test environment."
}

main "$@"

