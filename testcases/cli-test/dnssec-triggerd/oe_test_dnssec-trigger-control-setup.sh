#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test dnssec-trigger-control-setup command 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dnssec-trigger
    mkdir dnssec-triggerd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start dnssec-triggerd
    SLEEP_WAIT 5
    dnssec-trigger-control-setup -h|grep "dnssec-trigger-control-setup.sh"
    CHECK_RESULT $? 0 0 "Failed to check the"
    dnssec-trigger-control-setup -u >dnssec-trigger-control-setup1.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -u"
    grep "setup in directory" dnssec-trigger-control-setup1.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -u'log"
    dnssec-trigger-control-setup -i >dnssec-trigger-control-setup2.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -i"
    grep "setup in directory" dnssec-trigger-control-setup2.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -i'log"
    dnssec-trigger-control-setup -s >dnssec-trigger-control-setup3.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -s"
    grep "Setup success. Certificates created." dnssec-trigger-control-setup3.log
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -s'log"
    dnssec-trigger-control-setup -d ./dnssec-triggerd/
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -d"
    test -d ./dnssec-triggerd
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -d'log"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop dnssec-triggerd
    DNF_REMOVE
    rm -rf dnssec-trigger-control-setup*.log dnssec-triggerd
    LOG_INFO "End to restore the test environment."
}

main "$@"
