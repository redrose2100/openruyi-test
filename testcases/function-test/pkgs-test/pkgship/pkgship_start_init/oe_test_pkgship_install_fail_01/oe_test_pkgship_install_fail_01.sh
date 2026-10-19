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
#@Desc      	:   Pkgship install test
#####################################
# shellcheck disable=SC1091
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    if rpm -qa | grep pkgship
    then
       dnf remove pkgship --assumeyes > ./remove.txt
    fi

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dnf install pkgship --assumeyes --repo=everything > ./install.txt 2>&1 &
    mv /etc/yum.repos.d/openEuler.repo /mnt/openEuler.repo
    SLEEP_WAIT 30
    systemctl status pkgship 2>&1 | grep "could not be found"
    CHECK_RESULT $? 0 0 "Install pkgship succeed unexpectly."
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ./remove.txt ./install.txt
    mv /mnt/openEuler.repo /etc/yum.repos.d/openEuler.repo
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}
main "$@"
