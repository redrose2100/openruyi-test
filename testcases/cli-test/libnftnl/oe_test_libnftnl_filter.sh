#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-06
# @License   :   Mulan PSL v2
# @Desc      :   Test libnftnl network rule filtering (IP/protocol/NAT/queue)
# ############################################

# shellcheck disable=SC2119,SC1091,SC1090
source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_TABLE="libnftnl_filter_test"
TEST_CHAIN="filter_chain"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnftnl nftables"
    nft flush ruleset 2>/dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test add_table: Create filter test table and chain
    nft add table inet "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft add table failed"
    nft add chain inet "$TEST_TABLE" "$TEST_CHAIN" "{ type filter hook input priority 0; }"
    CHECK_RESULT $? 0 0 "nft add chain failed"

    # Test filter_src_ip: Filter by source IP address
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr 192.168.1.100 accept
    CHECK_RESULT $? 0 0 "nft add src ip rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "192.168.1.100"
    CHECK_RESULT $? 0 0 "nft list src ip rule verification failed"

    # Test filter_dst_ip: Filter by destination IP address
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip daddr 10.0.0.1 accept
    CHECK_RESULT $? 0 0 "nft add dst ip rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "10.0.0.1"
    CHECK_RESULT $? 0 0 "nft list dst ip rule verification failed"

    # Test filter_protocol: Filter by UDP protocol
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" udp dport 53 accept
    CHECK_RESULT $? 0 0 "nft add udp rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "udp"
    CHECK_RESULT $? 0 0 "nft list udp rule verification failed"

    # Test filter_icmp: Filter by ICMP protocol
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip protocol icmp accept
    CHECK_RESULT $? 0 0 "nft add icmp rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "icmp"
    CHECK_RESULT $? 0 0 "nft list icmp rule verification failed"

    # Test filter_tcp: Filter by TCP protocol
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 443 accept
    CHECK_RESULT $? 0 0 "nft add tcp rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "443"
    CHECK_RESULT $? 0 0 "nft list tcp rule verification failed"

    # Test filter_port_range: Filter by port range
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 1000-2000 accept
    CHECK_RESULT $? 0 0 "nft add port range rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "1000-2000"
    CHECK_RESULT $? 0 0 "nft list port range rule verification failed"

    # Test filter_multi_port: Filter by multiple ports
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport "{ 8080, 8443 }" accept
    CHECK_RESULT $? 0 0 "nft add multi-port rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "8080"
    CHECK_RESULT $? 0 0 "nft list multi-port rule verification failed"

    # Test filter_drop: Add drop rule
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr 172.16.0.0/16 drop
    CHECK_RESULT $? 0 0 "nft add drop rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "drop"
    CHECK_RESULT $? 0 0 "nft list drop rule verification failed"

    # Test filter_log: Add log rule
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip protocol tcp log prefix "DROP " drop
    CHECK_RESULT $? 0 0 "nft add log rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "log prefix"
    CHECK_RESULT $? 0 0 "nft list log rule verification failed"

    # Test filter_combo: Combine multiple filter conditions
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip saddr 192.168.1.0/24 tcp dport 80 accept
    CHECK_RESULT $? 0 0 "nft add combo rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "tcp dport 80"
    CHECK_RESULT $? 0 0 "nft list combo rule verification failed"

    # Test filter_counter: Add rule with counter
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" ip daddr 10.0.0.10 counter accept
    CHECK_RESULT $? 0 0 "nft add counter rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "counter"
    CHECK_RESULT $? 0 0 "nft list counter rule verification failed"

    # Test snat_chain: Create SNAT chain and rule
    nft add chain inet "$TEST_TABLE" snat_chain "{ type nat hook postrouting priority 100; }"
    CHECK_RESULT $? 0 0 "nft add snat chain failed"
    nft add rule inet "$TEST_TABLE" snat_chain ip saddr 10.0.0.0/24 snat to 192.168.1.100
    CHECK_RESULT $? 0 0 "nft add snat rule failed"
    nft list chain inet "$TEST_TABLE" snat_chain | grep -E "snat to|192\.168\.1\.100"
    CHECK_RESULT $? 0 0 "nft list snat rule verification failed"

    # Test dnat_chain: Create DNAT chain and rule
    nft add chain inet "$TEST_TABLE" dnat_chain "{ type nat hook prerouting priority 0; }"
    CHECK_RESULT $? 0 0 "nft add dnat chain failed"
    nft add rule inet "$TEST_TABLE" dnat_chain tcp dport 8080 dnat ip to 10.0.0.5
    CHECK_RESULT $? 0 0 "nft add dnat rule failed"
    nft list chain inet "$TEST_TABLE" dnat_chain | grep -E "dnat ip to|10\.0\.0\.5"
    CHECK_RESULT $? 0 0 "nft list dnat rule verification failed"

    # Test queue_rule: Create queue chain and rule
    nft add chain inet "$TEST_TABLE" queue_chain "{ type filter hook input priority 100; }"
    CHECK_RESULT $? 0 0 "nft add queue chain failed"
    nft add rule inet "$TEST_TABLE" queue_chain ip protocol udp queue to 0
    CHECK_RESULT $? 0 0 "nft add queue rule failed"
    nft list chain inet "$TEST_TABLE" queue_chain | grep "queue"
    CHECK_RESULT $? 0 0 "nft list queue rule verification failed"

    # Test delete_all: Delete entire table
    nft delete table inet "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft delete table failed"
    ! nft list tables 2>/dev/null | grep -qw "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft delete table verification failed"

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