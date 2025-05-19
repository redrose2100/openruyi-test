#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2022-12-04
#@License       :   Mulan PSL v2
#@Desc          :   Default rules for firewall
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL firewalld
    systemctl start firewalld
    CHECK_RESULT "$(firewall-cmd --state)" "running" 0 "firewalld.service not running"
    rm -rf ./*.info
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    firewall-cmd --get-zones|grep -E "block dmz drop external home internal public trusted work|block dmz drop external home internal libvirt nm-shared public trusted work"
    CHECK_RESULT $? 0 0 "check default exists zone fail"
    firewall-cmd --get-target --permanent|grep "default"
    CHECK_RESULT $? 0 0 "check default target fail"
    firewall-cmd --get-default-zone|grep "public"
    CHECK_RESULT $? 0 0 "check default zone fail"

    NODE1_Interface=$(ip a |grep "${NODE1_IPV4}" -B2 |head -1 |awk -F ":" '{print $2}' |awk '{print $1}')
    firewall-cmd --list-all |grep interfaces |awk '{print $NF}'|grep "${NODE1_Interface}"
    CHECK_RESULT $? 0 0 "check values of interfaces in runtime public zone fail"
    firewall-cmd --list-all --permanent |grep interfaces |awk '{print $1}'|grep "interfaces:"
    CHECK_RESULT $? 0 0 "check values of interfaces in permanent public zone fail"
    firewall-cmd --list-all |head -1|grep "public (active)"
    CHECK_RESULT $? 0 0 "runtime public zone status fail"
    firewall-cmd --list-all --permanent |head -1|grep "public"
    CHECK_RESULT $? 0 0 "permanent public zone fail"

    firewall-cmd --list-all |grep -v -E 'interfaces|public' > runtime_rule.info
    firewall-cmd --list-all --permanent |grep -v -E 'interfaces|public' > permanent_rule.info
    diff runtime_rule.info permanent_rule.info -b
    CHECK_RESULT $? 0 0 "compare other values of runtime permanent fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./*.info
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
