#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023-07-11
# @License   :   Mulan PSL v2
# @Desc      :   Use ctags case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8   
    DNF_INSTALL "ctags"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ctags --list-languages|grep -i ant
    CHECK_RESULT $? 0 0 "recognition language failure"
    ctags --list-maps|grep build.xml
    CHECK_RESULT $? 0 0  "failed to view extended language"
    ctags --list-kinds|grep projects
    CHECK_RESULT $? 0 0  "failed to view the syntax element"
    ctags --list-kinds=c++|grep classes
    CHECK_RESULT $? 0 0  "failed to view c++ syntax elements"
    ctags --version|grep Copyright
    CHECK_RESULT $? 0 0  "check command fail"
    ctags --help|grep Usage
    CHECK_RESULT $? 0 0  "check version fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"

