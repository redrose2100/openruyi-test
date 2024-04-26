#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhuwenshuo
#@Contact   	:   1003254035@qq.com
#@Date          :   2023/02/21
#@License   	:   Mulan PSL v2
#@Desc      	:   command test whois
#失败原因结论:这个issue中已经做出解答，whois功能正常。本issue中提到的问题，出现的原因是在某些内网中，43端口的信息会被网关所丢弃，无法建立链接所导致的。可以查看链接https://gitee.com/src-openeuler/whois/issues/I6568Z
#####################################
# shellcheck disable=SC2009,SC2126

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "whois net-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    # test basic
    whois baidu.com | grep "Domain Name: baidu.com"
    CHECK_RESULT $? 0 0 "test whois basic failed"
    # test -h
    whois -h whois.networksolutions.com networksolutions.com | grep "Tech Email: corpdomains@newfold.com"
    CHECK_RESULT $? 0 0 "test whois -h failed"
    # test --host
    whois --host whois.networksolutions.com networksolutions.com | grep "Tech Email: corpdomains@newfold.com"
    CHECK_RESULT $? 0 0 "test whois --host failed"
    # test -p
    whois -p 8090 Lx138.COm &
    sleep 2
    portnum=$(netstat -nap | grep whois | awk '{print $5}' | awk -F ":" '{print $2}')
    if [[ ${portnum} == 8090 ]]; then
      echo "aa" | grep "aa"
    else
      echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "test whois -p failed"
    kill -9 "$(ps -ef | grep "whois -p" | grep -v "grep" | awk '{print $2}')"
    # test --port
    whois --port 8090 Lx138.COm &
    sleep 2
    portnum=$(netstat -nap | grep whois | awk '{print $5}' | awk -F ":" '{print $2}')
    if [[ ${portnum} == 8090 ]]; then
      echo "aa" | grep "aa"
    else
      echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "test whois --port failed"
    kill -9 "$(ps -ef | grep "whois --port" | grep -v "grep" | awk '{print $2}')"
    # test -I
    whois -I baidu.com | grep "status:       ACTIVE"
    CHECK_RESULT $? 0 0 "test whois -I failed"
    # test -H
    whois -H baidu.com | grep "You are not authorized to access or query"
    CHECK_RESULT $? 1 0 "test whois -H failed"
    # test --verbose
    whois --verbose baidu.com | grep "Registrar Abuse Contact Phone"
    CHECK_RESULT $? 0 0 "test whois --verbose failed"
    # test --help
    whois --help | grep "Usage: whois "
    CHECK_RESULT $? 0 0 "test whois --help failed"
    # test --version
    whois --version 
    CHECK_RESULT $? 0 0 "test whois --version failed"
    # test -l
    whois -h whois.apnic.net -l 202.12.29.0 | grep "netname:        APNIC-SERVICES-AU"
    CHECK_RESULT $? 0 0 "test whois -l failed"
    # test -L
    num=$(whois -L 172.0.0.1 | grep "role:           Internet Assigned Numbers Authority" | wc -l)
    if [[ $num == 2 ]]; then
      echo "aa" | grep "aa"
    else
      echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "test whois -L failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
