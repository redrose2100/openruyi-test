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
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-04-06
#@License       :   Mulan PSL v2
#@Desc          :   the function of iptables-restore
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp /etc/sysconfig/iptables /etc/sysconfig/iptables-bak
    iptables -I INPUT -p tcp -m tcp --dport 65535 -j ACCEPT
    iptables-save > /etc/sysconfig/iptables
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    CHECK_RESULT "$(grep 65535 /etc/sysconfig/iptables)" "-A INPUT -p tcp -m tcp --dport 65535 -j ACCEPT" 0 "/etc/sysconfig/iptables exists 65535 rule"
    CHECK_RESULT "$(iptables-save |grep 65535)" "-A INPUT -p tcp -m tcp --dport 65535 -j ACCEPT" 0 "iptables-save exists 65535 rule"

    sed -i "/65535/d" /etc/sysconfig/iptables
    grep "\-A INPUT -p tcp -m tcp --dport 65535 -j ACCEPT" /etc/sysconfig/iptables
    CHECK_RESULT $? 0 1 "/etc/sysconfig/iptables is not exist 65535 rule"
    CHECK_RESULT "$(iptables-save |grep 65535)" "-A INPUT -p tcp -m tcp --dport 65535 -j ACCEPT" 0 "iptables-save exists 65535 rule"

    iptables-restore < /etc/sysconfig/iptables
    CHECK_RESULT $? 0 0 "restore rules"
    iptables-save |grep "\-A INPUT -p tcp -m tcp --dport 65535 -j ACCEPT"
    CHECK_RESULT $? 0 1 "iptables-save is not exist 65535 rule"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/sysconfig/iptables-bak /etc/sysconfig/iptables -f
    LOG_INFO "End to restore the test environment."
}

main "$@"
