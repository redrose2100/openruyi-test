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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   Test sudo_cvtsudoers
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp /etc/sudoers /etc/sudoers_bak
    mkdir /tmp/test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/test
    cvtsudoers -b ou=SUDOers,dc=my-domain,dc=com -o sudoers.ldif /etc/sudoers
    test -e sudoers.ldif
    CHECK_RESULT $? 0 0 " sudoers.ldif generation failure"
    cvtsudoers -f json -o sudoers.json /etc/sudoers
    test -e sudoers.json
    CHECK_RESULT $? 0 0 " sudoers.json generation failure"
    cvtsudoers -f sudoers -m user=ambrose,host=hastur /etc/sudoers
    CHECK_RESULT $? 0 0 "cvtsudoers -f sudoers error"
    cvtsudoers -ep -f sudoers -m user=ambrose,host=hastur /etc/sudoers
    CHECK_RESULT $? 0 0 "cvtsudoers -ep error"
    cvtsudoers -i ldif -f sudoers -o sudoers.new sudoers.ldif
    test -e sudoers.new
    CHECK_RESULT $? 0 0 " sudoers.new generation failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/sudoers_bak /etc/sudoers
    rm -rf /tmp/test
    LOG_INFO "End to restore the test environment."
}

main "$@"
