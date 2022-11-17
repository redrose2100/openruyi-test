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
    LOG_INFO "Start testing..."
    LOG_INFO "Start to run test the value --help."
    dnssec-trigger-control -h|grep "dnssec-trigger-control \[options\] command"
    CHECK_RESULT $?

    #启动dnssec服务
    systemctl start dnssec-triggerd
    CHECK_RESULT $?
    sleep 5

    LOG_INFO "Start to run test the dnssec-trigger-control's value result"
    dnssec-trigger-control results > dnssec-trigger-control-result.log &
    CHECK_RESULT $?
    ps -ef|grep "dnssec-trigger-control results"|grep -v grep
    CHECK_RESULT $?
    cat dnssec-trigger-control-result.log |grep "state"

    for ((i=0; i < 5; i++))
    do
        sleep 3
        process_exist=`ps -ef|grep "dnssec-trigger-control results"|grep -v grep|wc -l`
        echo $process_exist
        if [ $process_exist -ge 1 ]
        then
              LOG_INFO "dnssec-trigger-control results process is running!"
        fi
    done

    LOG_INFO "Start to run test the dnssec-trigger-control's value stop"
    dnssec-trigger-control stop
    CHECK_RESULT $?
    process_exist=`ps -ef|grep "dnssec-trigger-control results"|grep -v grep|wc -l`
    if [ $process_exist -eq 0 ]
    then
        LOG_INFO "The dnssec-trigger-control results process is killed!"
    fi

    systemctl stop dnssec-triggerd
    CHECK_RESULT $?
    sleep 5
    #重新启动dnssec服务
    systemctl start dnssec-triggerd
    CHECK_RESULT $?
    sleep 5

    LOG_INFO "Start to run test the dnssec-trigger-control's value cmdtray"
    dnssec-trigger-control cmdtray&
    CHECK_RESULT $?
    ps -ef|grep "dnssec-trigger-control cmdtray"|grep -v grep
    CHECK_RESULT $?
    for ((i=0; i < 5; i++))
    do
        sleep 3
        process_exist=`ps -ef|grep "dnssec-trigger-control cmdtray"|grep -v grep|wc -l`
        echo $process_exist
        if [ $process_exist -ge 1 ]
        then
              LOG_INFO "dnssec-trigger-control cmdtray process is running!"
        fi
    done
    #kill cmdtray process
    ps -ef|grep cmdtray|grep -v grep|awk {'print $2'}|xargs kill -9
    process_exist=`ps -ef|grep "dnssec-trigger-control cmdtray"|grep -v grep|wc -l`
    LOG_INFO $process_exist
    if [ $process_exist -eq 0 ]
    then
        LOG_INFO "The dnssec-trigger-control cmdtray process is killed!"
    fi



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
