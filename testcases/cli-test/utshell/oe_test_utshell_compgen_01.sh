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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024.05.22
# @License   :   Mulan PSL v2
# @Desc      :   compgen using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    useradd -m -s /bin/utshell test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su - test -c "compgen --help |grep -i compgen"
    CHECK_RESULT $? 0 0 "View Help Failed"
    su - test -c "compgen -c"
    CHECK_RESULT $? 0 0 "Execution failed"
    su - test -c "compgen -a |grep -i ll"
    CHECK_RESULT $? 0 0 "Failed to view alias"
    su - test -c "compgen -b |grep -i wait"
    CHECK_RESULT $? 0 0 "View plugin failed"
    su - test -c "compgen -W "aa ab bb cc" -- \"a\" |grep -E 'aa|ab'"
    CHECK_RESULT $? 0 0 "Command execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"