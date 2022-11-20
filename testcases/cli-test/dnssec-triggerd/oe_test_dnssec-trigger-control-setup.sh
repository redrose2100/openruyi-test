#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test dnssec-triggerd.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL dnssec-trigger
    rm -rf ./dnssec-triggerd
    rm -rf dnssec-trigger-control-setup*.log
    mkdir ./dnssec-triggerd
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5
    LOG_INFO "End of environmental preparation!"

}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Start to run test the value --help."
    dnssec-trigger-control-setup -h|grep "dnssec-trigger-control-setup.sh"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control-setup's value -u"
    dnssec-trigger-control-setup -u >dnssec-trigger-control-setup1.log
    CHECK_RESULT $?
    cat dnssec-trigger-control-setup1.log |grep "setup in directory"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control-setup's value -i"
    dnssec-trigger-control-setup -i >dnssec-trigger-control-setup2.log
    CHECK_RESULT $?
    cat dnssec-trigger-control-setup2.log |grep "setup in directory"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control-setup's value -s"
    dnssec-trigger-control-setup -s >dnssec-trigger-control-setup3.log
    CHECK_RESULT $?
    cat dnssec-trigger-control-setup3.log |grep "Setup success. Certificates created."
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control-setup's value -d"
    dnssec-trigger-control-setup -d ./dnssec-triggerd/
    CHECK_RESULT $?
    ls -l ./dnssec-triggerd
    CHECK_RESULT $?


}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./dnssec-triggerd/*
    rm -rf dnssec-trigger-control-setup*.log
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
