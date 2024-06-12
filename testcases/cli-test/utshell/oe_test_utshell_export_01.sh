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
# @Author    :   xietian
# @Contact   :   xietian@uniontech.com
# @Date      :   2024.06.12
# @License   :   Mulan PSL v2
# @Desc      :   test utshell export
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    utshell -c "SHELLVAR=helloworld && export SHELLVAR && export -p | grep hello"
    CHECK_RESULT $? 0 0 "export var fail"
    utshell -c "SHELLVAR=helloworld && export SHELLVAR && export -n SHELLVAR && export -p | grep hello"
    CHECK_RESULT $? 1 0 "delete export var fail"
    CHECK_RESULT $? 0 0 "Execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"