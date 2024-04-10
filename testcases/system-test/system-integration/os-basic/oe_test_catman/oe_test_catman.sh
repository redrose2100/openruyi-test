#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test-catman
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    catman 1|grep "man"
    CHECK_RESULT $? 0 0 "failed to process Section 1"
    catman -d|grep man
    CHECK_RESULT $? 0 0  "description Failed to print debugging information"
    catman -C 1 |grep "Updating cat files for section"
    CHECK_RESULT $? 0 0  "failed to set the file using this user"
    catman -M catman -M /var/cache/man/index.db
    CHECK_RESULT $? 0 0  "failed to set path"
    catman -V|grep catman
    CHECK_RESULT $? 0 0  "check version fail"
    catman -?|grep catman
    CHECK_RESULT $? 0 0  "check help message fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

