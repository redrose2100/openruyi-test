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
    rm -rf dnssec-trigger-control*.log
    mkdir ./dnssec-triggerd
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5
    LOG_INFO "End of environmental preparation!"

}

function run_test() {
    #启动dnssec服务
    systemctl start dnssec-triggerd
    CHECK_RESULT $?
    sleep 5

    LOG_INFO "Start to run test the dnssec-trigger-control's value unsafe"
    dnssec-trigger-control status >dnssec-trigger-control-unsafe.log
    CHECK_RESULT $?
    sleep 3
    #确认执行unsafe命令前，status命令执行无报错信息
    LOG_INFO "Start to run grep unsafe's log-test1"
    cat dnssec-trigger-control-unsafe.log|grep "TCP connection failure"
    CHECK_RESULT $? 1

    dnssec-trigger-control unsafe
    CHECK_RESULT $?
    dnssec-trigger-control status >dnssec-trigger-control-unsafe.log
    CHECK_RESULT $?
    sleep 3
    #确认执行unsafe命令后，status命令执行有报错信息
    LOG_INFO "Start to run grep unsafe's log-test2"
    cat dnssec-trigger-control-unsafe.log|grep "TCP connection failure"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value hotspot_signon"
    dnssec-trigger-control status >dnssec-trigger-control-hotspot_signon.log
    CHECK_RESULT $?
    sleep 3
    #确认执行hotspot_signon命令前，status命令执行无"forced_insecure"信息
    LOG_INFO "Start to run grep hotspot_signon's log-test1"
    cat dnssec-trigger-control-hotspot_signon.log|grep "forced_insecure"
    CHECK_RESULT $? 1

    #确认执行hotspot_signon命令后，status命令执行有"forced_insecure"信息
    dnssec-trigger-control hotspot_signon
    CHECK_RESULT $?
    sleep 3
    LOG_INFO "Start to run grep hotspot_signon's log-test2"
    dnssec-trigger-control status >dnssec-trigger-control-hotspot_signon.log
    CHECK_RESULT $?
    cat dnssec-trigger-control-hotspot_signon.log|grep "forced_insecure"
    CHECK_RESULT $?


    LOG_INFO "Start to run test the dnssec-trigger-control's value skip_http"
    dnssec-trigger-control skip_http
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value reprobe"
    dnssec-trigger-control reprobe
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value -v"
    dnssec-trigger-control  test_tcp -s 127.0.0.1
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value -c"
    dnssec-trigger-control  test_tcp -c ./dnssec-trigger.conf 
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value -c"
    dnssec-trigger-control test_update
    CHECK_RESULT $?
    
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./dnssec-triggerd/*
    rm -rf dnssec-trigger-control*.log
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
