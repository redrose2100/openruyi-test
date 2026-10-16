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
# @Date      :   2025-10-20
# @License   :   Mulan PSL v2
# @Desc      :   Command corelist test02
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    TEST_DIR="/tmp/corelist_test"
    mkdir -p "$TEST_DIR"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    perl_version=$(perl -e 'print $]')
    corelist -v "$perl_version" | grep "The following modules were in perl"
    CHECK_RESULT $? 0 0 "Failed to list modules for specific Perl version (-v version)"
    corelist -v "$perl_version" Data::Dumper | grep "Data::Dumper"
    CHECK_RESULT $? 0 0 "Failed to query module for specific Perl version"
    corelist -r | grep "following perl versions"
    CHECK_RESULT $? 0 0 "Failed to list Perl release dates (-r)"
    corelist -r "$perl_version" | grep released
    CHECK_RESULT $? 0 0 "Failed to get release date for specific version (-r version)"
    corelist -? | grep -E "Usage|Options"
    CHECK_RESULT $? 0 0 "Failed to display help (-?)"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
