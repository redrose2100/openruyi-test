#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-05
# @License   :   Mulan PSL v2
# @Desc      :   Test nftables network rule filtering management: IP filter, protocol filter, NAT, queue
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_TABLE="libnftnl_filter"
TEST_CHAIN="libnftnl_filter_chain"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnftnl nftables"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test add_table: Create nftables table
    nft add table inet "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft add table failed"

    # Test add_chain: Create filter chain
    nft add chain inet "$TEST_TABLE" "$TEST_CHAIN" "{ type filter hook input priority 0 ; policy accept ; }"
    CHECK_RESULT $? 0 0 "nft add chain failed"

    # Test filter_src_ip: Filter by source IP address
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr 10.0.0.1 accept
    CHECK_RESULT $? 0 0 "nft add rule with src IP filter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "10.0.0.1"
    CHECK_RESULT $? 0 0 "nft list src IP filter verification failed"

    # Test filter_dst_ip: Filter by destination IP address
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip daddr 192.168.1.1 accept
    CHECK_RESULT $? 0 0 "nft add rule with dst IP filter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "192.168.1.1"
    CHECK_RESULT $? 0 0 "nft list dst IP filter verification failed"

    # Test filter_protocol: Filter by protocol (UDP)
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" udp dport 53 accept
    CHECK_RESULT $? 0 0 "nft add rule with UDP filter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "udp"
    CHECK_RESULT $? 0 0 "nft list UDP filter verification failed"

    # Test filter_icmp: Filter by ICMP protocol
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip protocol icmp accept
    CHECK_RESULT $? 0 0 "nft add rule with ICMP filter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "icmp"
    CHECK_RESULT $? 0 0 "nft list ICMP filter verification failed"

    # Test filter_combo: Multi-condition filter (src IP + port + protocol)
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr 10.0.0.2 tcp dport 443 accept
    CHECK_RESULT $? 0 0 "nft add rule with combo filter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "443"
    CHECK_RESULT $? 0 0 "nft list combo filter verification failed"

    # Test filter_src_set: Filter by source IP set
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr "{ 10.0.0.3, 10.0.0.4 }" accept
    CHECK_RESULT $? 0 0 "nft add rule with src IP set failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "10.0.0.3"
    CHECK_RESULT $? 0 0 "nft list src IP set filter verification failed"

    # Test filter_port_range: Filter by port range
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 1000-2000 accept
    CHECK_RESULT $? 0 0 "nft add rule with port range failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep -E "1000|2000"
    CHECK_RESULT $? 0 0 "nft list port range filter verification failed"

    # Test filter_log: Add log action rule
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 9090 log prefix 'TEST-LOG' accept
    CHECK_RESULT $? 0 0 "nft add rule with log action failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "TEST-LOG"
    CHECK_RESULT $? 0 0 "nft list log action verification failed"

    # Test filter_drop: Add drop rule
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 3306 drop
    CHECK_RESULT $? 0 0 "nft add drop rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "drop"
    CHECK_RESULT $? 0 0 "nft list drop rule verification failed"

    # Test update_rule: Insert rule at specific position
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 8088 accept
    CHECK_RESULT $? 0 0 "nft add rule before insert failed"
    ref_handle=$(nft -a list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep "tcp dport 8088" | awk '{print $NF}')
    [ -n "$ref_handle" ]
    CHECK_RESULT $? 0 0 "nft get reference handle failed"
    nft insert rule inet "$TEST_TABLE" "$TEST_CHAIN" handle "$ref_handle" tcp dport 8081 accept
    CHECK_RESULT $? 0 0 "nft insert rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "8081"
    CHECK_RESULT $? 0 0 "nft list insert rule verification failed"

    # Test nat_snat: Add SNAT rule
    nft add chain inet "$TEST_TABLE" snat_test "{ type nat hook postrouting priority 100; }"
    CHECK_RESULT $? 0 0 "nft add SNAT chain failed"
    nft add rule inet "$TEST_TABLE" snat_test ip saddr 10.0.0.0/24 snat to 192.168.1.100
    CHECK_RESULT $? 0 0 "nft add SNAT rule failed"
    nft list chain inet "$TEST_TABLE" snat_test | grep -E "snat|192.168.1.100"
    CHECK_RESULT $? 0 0 "nft list SNAT rule verification failed"

    # Test nat_dnat: Add DNAT rule
    nft add chain inet "$TEST_TABLE" dnat_test "{ type nat hook prerouting priority 0; }"
    CHECK_RESULT $? 0 0 "nft add DNAT chain failed"
    nft add rule inet "$TEST_TABLE" dnat_test tcp dport 8080 dnat ip to 10.0.0.5
    CHECK_RESULT $? 0 0 "nft add DNAT rule failed"
    nft list chain inet "$TEST_TABLE" dnat_test | grep -E "dnat|10.0.0.5"
    CHECK_RESULT $? 0 0 "nft list DNAT rule verification failed"

    # Test queue_rule: Add queue rule
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 9999 queue to 0
    CHECK_RESULT $? 0 0 "nft add queue rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "queue"
    CHECK_RESULT $? 0 0 "nft list queue rule verification failed"

    # Test counter_rule: Add rule with counter
    nft add counter inet "$TEST_TABLE" test_counter
    CHECK_RESULT $? 0 0 "nft add counter failed"
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 7777 counter accept
    CHECK_RESULT $? 0 0 "nft add counter rule failed"
    nft list counter inet "$TEST_TABLE" test_counter > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list counter verification failed"

    # Test delete_specific_rule: Delete rule by handle
    del_handle=$(nft -a list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep "tcp dport 3306" | awk '{print $NF}')
    [ -n "$del_handle" ]
    CHECK_RESULT $? 0 0 "nft get delete handle failed"
    nft delete rule inet "$TEST_TABLE" "$TEST_CHAIN" handle "$del_handle"
    CHECK_RESULT $? 0 0 "nft delete specific rule failed"

    # Test flush_chain: Flush chain
    nft flush chain inet "$TEST_TABLE" "$TEST_CHAIN" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft flush chain failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep -cE '^\s+(tcp|udp|ip|icmp)' > /dev/null 2>&1
    [ $? -ne 0 ]
    CHECK_RESULT $? 0 0 "nft chain flush verification failed"

    # Test delete_table: Delete table
    nft delete table inet "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft delete table failed"
    nft list tables 2>/dev/null | grep -qw "$TEST_TABLE"
    [ $? -ne 0 ]
    CHECK_RESULT $? 0 0 "nft delete table verification failed"

    # Test flush_ruleset: Flush ruleset
    nft flush ruleset > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft flush ruleset failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    nft delete table inet "$TEST_TABLE" 2>/dev/null
    nft flush ruleset 2>/dev/null
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
