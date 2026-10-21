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
# @Date      :   2024.08.14
# @License   :   Mulan PSL v2
# @Desc      :   dirs using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd || exit
    utshell -c "dirs --help" | grep -i dirs
    CHECK_RESULT $? 0 0 "dirs --help failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs -l | grep -i root"
    CHECK_RESULT $? 0 0 "dirs -l execution failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs -p | grep -i root"
    CHECK_RESULT $? 0 1 "dirs -p execution failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs -v | egrep -e '0|1|2|3'"
    CHECK_RESULT $? 0 0 "dirs -v execution failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs +2 | grep -i Pictures"
    CHECK_RESULT $? 0 0 "dirs +2 execution failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs -2 | grep -i Videos "
    CHECK_RESULT $? 0 0 "dirs -2 execution failed"
    utshell -c "pushd -n ~/Desktop/; pushd -n ~/Pictures/; pushd -n ~/Videos/; dirs -c; dirs -l | egrep -ie 'Desktop|Pictures|Videos'"
    CHECK_RESULT $? 0 1 "dirs -c execution failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"