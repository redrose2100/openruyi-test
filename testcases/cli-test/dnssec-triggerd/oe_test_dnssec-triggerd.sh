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
    LOG_INFO "End of environmental preparation!"
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5

}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Start to run test the value --help."
    dnssec-triggerd -h|grep "dnssec-triggerd \[options\]"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -v"
    dnssec-triggerd -v
    CHECK_RESULT $?
    #检验进程是否存在和返回值
    ps -ef|grep "dnssec-triggerd -v"|grep -v grep
    CHECK_RESULT $?
    #关闭该进程
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5


    LOG_INFO "Start to run test the value -d"
    dnssec-triggerd -d &
    CHECK_RESULT $?
    #检验进程是否存在和返回值
    ps -ef|grep "dnssec-triggerd -d"|grep -v grep
    CHECK_RESULT $?
    #关闭该进程
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5


    LOG_INFO "Start to run test the value -c"
    dnssec-triggerd -c ./dnssec-trigger.conf
    CHECK_RESULT $?
    #检验进程是否存在和返回值
    ps -ef|grep "dnssec-triggerd -c"|grep -v grep
    CHECK_RESULT $?
    #关闭该进程
    systemctl start dnssec-triggerd
    sleep 5
    systemctl stop dnssec-triggerd
    sleep 5
    
    LOG_INFO "Start to run test the value -u"
    #启动服务
    systemctl start dnssec-triggerd
    CHECK_RESULT $?
    dnssec-triggerd -u
    #检验进程是否存在和返回值
    CHECK_RESULT $?
    ps -ef|grep "dnssec-triggerd -d"|grep -v grep
    CHECK_RESULT $?
    #关闭该进程
    systemctl stop dnssec-triggerd
    sleep 5
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    systemctl start dnssec-triggerd
    systemctl stop dnssec-triggerd
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
