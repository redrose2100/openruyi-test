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
# @Date      :   2023-11-2
# @License   :   Mulan PSL v2
# @Desc      :   Use fc-match case
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
    fc-match
    CHECK_RESULT $? 0 0 "Failed to list the best font matching the pattern"
    fc-match -s
    CHECK_RESULT $? 0 0 "Failed to display the sorted match list"
    fc-match -a
    CHECK_RESULT $? 0 0 "Failed to display an unpruned sorted match list"
    fc-match -v|grep "elts"
    CHECK_RESULT $? 0 0 "Failed to display the entire font matching mode in detail"
    fc-match -b|grep "elts"
    CHECK_RESULT $? 0 0 "Summary shows that the entire font matching mode failed"
    fc-match -f json|grep json
    CHECK_RESULT $? 0 0 "Failed to use the specified output format"
    fc-match -V
    CHECK_RESULT $? 0 0  "Description Failed to view the version information"
    fc-match -h
    CHECK_RESULT $? 0 0  "Description Failed to view the help information"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "End to clean the test environment."
}

main "$@"
