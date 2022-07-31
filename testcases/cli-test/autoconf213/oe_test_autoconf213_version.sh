#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   LiuZiyi
# @Contact   :   lavandejoey@outlook.com
# @Date      :   2022/4/29
# @Desc      :   Test "--version" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL autoconf213
    LOG_INFO "Test environment is ready."
}

function run_test() {
    LOG_INFO "Start to run version test."
    autoconf-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: autoconf-2.13 --version run failed"
    autoheader-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --version run failed"
    autoreconf-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --version run failed"
    autoupdate-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 --version run failed"
    ifnames-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: ifnames-2.13 --version run failed"
    LOG_INFO "End to run test."
}

function post_test() {
    DNF_REMOVE autoconf213
    LOG_INFO "Test environment restored."
}

main "$@"
