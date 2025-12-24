#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Test oedp init command 
# #############################################
# shellcheck disable=SC2027,SC2086

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL oedp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp repo update
    CHECK_RESULT $? 0 0 "Failed to execute oedp repo update command"

    plugin=$(curl -s https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/plugins/ | grep -o 'kubernetes-[0-9]\+\(\.[0-9]\+\)*' | sort -V | tail -1)
    oedp init "$plugin" 2>&1 | grep "process success"
    CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin""

    test -d "$plugin" 
    CHECK_RESULT $? 0 0 "Failed to check "$plugin""

    rm -rf "$plugin"
    oedp init https://repo.oepkgs.net/openEuler/rpm/openEuler-24.03-LTS/contrib/oedp/plugins/"$plugin".tar.gz 2>&1 | grep "process success"
    CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin" by url"
    
    test -d "$plugin"
    CHECK_RESULT $? 0 0 "Failed to check "$plugin""

    rm -rf "$plugin"
    oedp init "$plugin" -p ~/"$plugin" 2>&1 | grep "process success"
    CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin" to home directory"

    test -d ~/"$plugin"
    CHECK_RESULT $? 0 0 "Failed to check "$plugin""

    rm -rf ~/"$plugin"
    oedp init "$plugin" -d ~ --force 2>&1 | grep "process success"
    CHECK_RESULT $? 0 0 "Forcefully initializing "$plugin" to/root directory failed "

    test -d ~/"$plugin"
    CHECK_RESULT $? 0 0 "Failed to check "$plugin""

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ~/"$plugin"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
