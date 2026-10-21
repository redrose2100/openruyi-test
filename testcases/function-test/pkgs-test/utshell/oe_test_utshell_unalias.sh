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
# @Author    :   xianglongfei
# @Contact   :   xianglongfei@uniontech.com
# @Date      :   2024.06.05
# @License   :   Mulan PSL v2
# @Desc      :   unalias using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    utshell -c "unalias --help" | grep -i unalias
    CHECK_RESULT $? 0 0 "unalias --help failed"
    utshell -c "alias lx=ls;alias -p" | grep -i lx
    CHECK_RESULT $? 0 0 "alias lx execution failed"
    utshell -c "alias lx=ls;unalias lx;lx"
    CHECK_RESULT $? 1 1 "unalias execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"