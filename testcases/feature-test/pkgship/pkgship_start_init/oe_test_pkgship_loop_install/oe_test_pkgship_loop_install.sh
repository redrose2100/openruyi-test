#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091
# shellcheck disable=SC2034
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    EXECUTE_T="60m"
    if rpm -qa | grep pkgship
    then
        dnf remove pkgship --assumeyes > ./remove.txt
    fi 
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    for i in $(seq 1 100); do
        dnf install pkgship --assumeyes --repo=everything > ./install.txt
        dnf remove pkgship --assumeyes > ./remove.txt
        LOG_INFO "test $i install or remove."
    done

    dnf install pkgship --assumeyes --repo=everything > ./install.txt
    ACT_SERVICE
    CHECK_RESULT $? 0 0 "Install failed."
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf install.txt remove.txt
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
