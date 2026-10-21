#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-10-16
# @License   :   Mulan PSL v2
# @Desc      :   Command corelist test01
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl perl-CoreList"
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    TEST_DIR="/tmp/corelist_test"
    mkdir -p "$TEST_DIR"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    corelist -v | grep "perl versions"
    CHECK_RESULT $? 0 0 "Failed to list Perl versions (-v)"
    corelist Data::Dumper | grep "Dumper was first released with perl"
    CHECK_RESULT $? 0 0 "Failed to query Data::Dumper module"
    corelist -a Data::Dumper | grep "Dumper was first released with perl"
    CHECK_RESULT $? 0 0 "Failed to list all versions of Data::Dumper (-a)"
    corelist -d Data::Dumper | grep "Dumper was first released with perl"
    CHECK_RESULT $? 0 0 "Failed to find first release by date (-d)"
    corelist /Test::/ | grep -E "Module::Metadata|Test::Builder|Test::Harness|Test::More"
    CHECK_RESULT $? 0 0 "Failed to query modules by regex"   
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
