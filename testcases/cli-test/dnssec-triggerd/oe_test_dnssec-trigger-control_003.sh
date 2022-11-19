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

    LOG_INFO "Start to run test the dnssec-trigger-control's value test_ssl"
    dnssec-trigger-control test_ssl
    CHECK_RESULT $?
    sleep 5
    dnssec-trigger-control status >dnssec-trigger-control-status.log
    CHECK_RESULT $?
    grep -rn "state: ssl secure" ./dnssec-trigger-control-status.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value test_tcp"
    dnssec-trigger-control test_tcp
    CHECK_RESULT $?
    sleep 5
    dnssec-trigger-control status >dnssec-trigger-control-status.log
    CHECK_RESULT $?
    grep -rn "state: tcp secure" ./dnssec-trigger-control-status.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the dnssec-trigger-control's value test_http"
    dnssec-trigger-control test_http
    CHECK_RESULT $?
    sleep 5
    dnssec-trigger-control status >dnssec-trigger-control-status.log
    CHECK_RESULT $?
    grep -rn "state: nodnssec secure http_insecure" ./dnssec-trigger-control-status.log
    CHECK_RESULT $?


    LOG_INFO "Start to run test the dnssec-trigger-control's value submit"
    dnssec-trigger-control submit 192.169.5.8
    CHECK_RESULT $?
    sleep 2
    for((i=0;i<5;i++))
    do
        dnssec-trigger-control status 2>&1 >dnssec-trigger-control-status.log
        CHECK_RESULT $?
        echo time = $i
        submit_exist=`cat dnssec-trigger-control-status.log |grep "192.169.5.8"|wc -l`
        if [ $submit_exist -ge 1 ]
        then
            LOG_INFO "dnssec-trigger-control submit is success "
            break
        fi 
        sleep 2
    done


    
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
