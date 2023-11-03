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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL whois
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    whois -h whois.apnic.net -K bai | grep "inetnum:"
    CHECK_RESULT $? 0 0 "test whois -K failed"
    whois -r baidu | grep "org-name:       Baidu"
    CHECK_RESULT $? 0 0 "test whois -r failed"
    whois -R baidu
    CHECK_RESULT $? 0 0 "test whois -R failed"
    whois -a baidu | grep "netname:"
    CHECK_RESULT $? 0 0 "test whois -a failed"
    whois -s RIPE-GRS baidu | grep "source:         RIPE-GRS"
    CHECK_RESULT $? 0 0 "test whois -s failed"
    whois -h whois.apnic.net -T domain -i mb APNIC-HM -g RIPE:3:N:0-0
    CHECK_RESULT $? 0 0 "test whois -g failed"
    whois -t domain baidu | grep "domain:"
    CHECK_RESULT $? 0 0 "test whois -t failed"
    whois -v domain baidu | grep "A short decription related to the object"
    CHECK_RESULT $? 0 0 "test whois -v failed"
    whois -q sources | grep "RIPE:3:N:0-0"
    CHECK_RESULT $? 0 0 "test whois -q failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
