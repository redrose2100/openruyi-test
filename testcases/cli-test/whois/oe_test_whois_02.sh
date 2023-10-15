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
    # test -m
    whois -m 172.0.0.1 | grep "no entries found"
    CHECK_RESULT $? 0 0 "test whois -m failed"
    # test -M
    whois -M baidu | grep "mnt-ref:        Baidueng"
    CHECK_RESULT $? 0 0 "test whois -M failed"
    # test -c
    whois -c google | grep "org-name:       Google UK"
    CHECK_RESULT $? 0 0 "test whois -c failed"
    # test -x
    whois -x google | grep "org-name:       Google UK"
    CHECK_RESULT $? 0 0 "test whois -x failed"
    # test -b
    whois -b 172.0.0.1
    CHECK_RESULT $? 0 0 "test whois -b failed"
    # test -B
    whois -h whois.ripe.net -B baidu | grep "e-mail:         gi-noc@baidu.com"
    CHECK_RESULT $? 0 0 "test whois -B failed"
    # test -G
    whois -h whois.ripe.net -G google | grep "address:        Google Inc"
    CHECK_RESULT $? 0 0 "test whois -G failed"
    # test -d
    whois -h whois.ripe.net -d bai | grep "netname:        BAI"
    CHECK_RESULT $? 0 0 "test whois -d failed"
    # test -i
    whois -h whois.apnic.net -T domain -i mb APNIC-HM | grep "admin-c:        DNS4-AP"
    CHECK_RESULT $? 0 0 "test whois -i failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
