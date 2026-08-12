#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run iptables testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    IPTABLES_AVAILABLE=0
    if ! iptables -L -n >/dev/null 2>&1; then
        LOG_WARN "iptables kernel module (ip_tables) not available, skip this case."
        IPTABLES_AVAILABLE=1
        exit 0
    fi
    iptables-save >iptables_bak
    ip6tables-save >ip6tables_bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run iptables test."
    iptables -A INPUT -t filter -p tcp --dport 80 -j DROP
    CHECK_RESULT $? 0 0 "check iptables -A INPUT -t filter -p tcp --dport 80 -j DROP failed!"
    iptables -L -n | grep -E "80" | grep "DROP"
    CHECK_RESULT $? 0 0 "check iptables -L -n failed!"
    iptables -D INPUT -t filter -p tcp --dport 80 -j DROP
    CHECK_RESULT $? 0 0 "check iptables -D INPUT -t filter -p tcp --dport 80 -j DROP failed!"
    iptables -N dropchain && iptables -A dropchain -j DROP && iptables -A INPUT -p udp --dport 80 -j dropchain
    CHECK_RESULT $? 0 0 "check iptables -N dropchain failed!"
    iptables -L -n | grep "dropchain (1 references)"
    CHECK_RESULT $? 0 0 "check iiptables -L -n failed!"
    iptables -A INPUT -p tcp --tcp-flags SYN,RST,ACK SYN --dport 80 -j ACCEPT && iptables -L -n | grep "80" | grep -E "flags|ACCEPT"
    CHECK_RESULT $? 0 0 "check iptables -A INPUT --tcp-flags SYN,RST,ACK SYN failed!"

    iptables-save >iptables_before.log
    CHECK_RESULT $? 0 0 "check iptables-save failed!"
    iptables -t filter -D INPUT 1
    CHECK_RESULT $? 0 0 "check iptables failed!"
    iptables-save >iptables_after.log
    CHECK_RESULT $? 0 0 "check iptables-save failed!"
    diff iptables_before.log iptables_after.log
    CHECK_RESULT $? 1 0 "check iptables-save failed!"

    echo "*filter
-A INPUT -p icmp -j DROP
COMMIT" >iptables_rule
    iptables-restore -t iptables_rule
    CHECK_RESULT $? 0 0 "check iptables-restore -t fail"
    iptables-restore -n iptables_rule
    CHECK_RESULT $? 0 0 "check iptables-restore -n fail"
    iptables-restore -c iptables_rule
    CHECK_RESULT $? 0 0 "check iptables-restore -c fail"

    ip6tables-save
    CHECK_RESULT $? 0 0 "check ip6tables-save fail"
    ip6tables-save -t filter | grep filter
    CHECK_RESULT $? 0 0 "check ip6tables-save -t filter  fail"

    echo "*filter
-A INPUT -p icmp -j DROP
COMMIT" >ip6tables_rule
    ip6tables-restore -t iptables_rule
    CHECK_RESULT $? 0 0 "check ip6tables-restore -t fail"
    ip6tables-restore -n iptables_rule
    CHECK_RESULT $? 0 0 "check ip6tables-restore -n fail"
    ip6tables-restore -c iptables_rule
    CHECK_RESULT $? 0 0 "check ip6tables-restore -c fail"

    LOG_INFO "End to run iptables test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    if [ "${IPTABLES_AVAILABLE:-0}" -eq 1 ]; then
        LOG_INFO "iptables not available, nothing to cleanup."
        return 0
    fi
    iptables -D INPUT -p udp --dport 80 -j dropchain
    iptables -D INPUT -p tcp --tcp-flags SYN,RST,ACK SYN --dport 80 -j ACCEPT
    iptables -F dropchain 2>/dev/null || true
    iptables -X dropchain 2>/dev/null || true
    ip6tables-restore -n ip6tables_bak
    iptables-restore -n iptables_bak
    rm -rf ip6tables_* iptables_*
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
