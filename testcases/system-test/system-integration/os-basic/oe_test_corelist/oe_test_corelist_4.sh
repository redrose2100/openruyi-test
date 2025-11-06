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
# @Date      :   2025-11-6
# @License   :   Mulan PSL v2
# @Desc      :   Command corelist test
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
    versions=$(corelist -v | head -5 | tail -2)
    if [ "$(echo "$versions" | wc -l)" -eq 2 ]; then
        version1=$(echo "$versions" | head -1)
        version2=$(echo "$versions" | tail -1)
        corelist --diff "$version1" "$version2"
        CHECK_RESULT $? 0 0 "Failed to compare Perl versions (--diff)"
    else
        LOG_WARN "Not enough Perl versions available for diff test"
    fi
    corelist --upstream Data::Dumper | grep "Data::Dumper was first released"
    CHECK_RESULT $? 0 0 "Failed to query module upstream info (--upstream)"
    corelist Unicode | grep "released"
    CHECK_RESULT $? 0 0 "Failed to query Unicode information"
    corelist -a Unicode | grep "released"
    CHECK_RESULT $? 0 0 "Failed to list all Unicode versions (-a Unicode)"        
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
