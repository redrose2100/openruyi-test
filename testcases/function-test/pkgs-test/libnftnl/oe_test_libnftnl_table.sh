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
# @Desc      :   Test libnftnl basic table operations (table/chain/rule/set/counter/map)
# ############################################

# shellcheck disable=SC2119,SC1091,SC1090
source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_TABLE="libnftnl_test"
TEST_CHAIN="test_chain"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnftnl nftables"
    nft flush ruleset 2>/dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test add_table: Create nftables table
    nft add table inet "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft add table failed"
    nft list tables | grep "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft list table verification failed"

    # Test add_chain: Create chain with filter hook
    nft add chain inet "$TEST_TABLE" "$TEST_CHAIN" "{ type filter hook input priority 0; }"
    CHECK_RESULT $? 0 0 "nft add chain failed"
    nft list table inet "$TEST_TABLE" | grep "$TEST_CHAIN"
    CHECK_RESULT $? 0 0 "nft list chain verification failed"

    # Test add_rule: Add basic rule (accept SSH)
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 22 accept
    CHECK_RESULT $? 0 0 "nft add rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep "tcp dport 22"
    CHECK_RESULT $? 0 0 "nft list rule verification failed"

    # Test add_set: Add named set for IP addresses
    nft add set inet "$TEST_TABLE" test_set '{ type ipv4_addr; }'
    CHECK_RESULT $? 0 0 "nft add set failed"
    nft list table inet "$TEST_TABLE" | grep "test_set"
    CHECK_RESULT $? 0 0 "nft list set verification failed"

    # Test add_set_element: Add element to set
    nft add element inet "$TEST_TABLE" test_set '{ 192.168.1.1 }'
    CHECK_RESULT $? 0 0 "nft add set element failed"
    nft list set inet "$TEST_TABLE" test_set 2>/dev/null | grep "192.168.1.1"
    CHECK_RESULT $? 0 0 "nft list set element verification failed"

    # Test add_counter: Add named counter
    nft add counter inet "$TEST_TABLE" test_counter
    CHECK_RESULT $? 0 0 "nft add counter failed"
    nft list counter inet "$TEST_TABLE" test_counter 2>/dev/null | grep "test_counter"
    CHECK_RESULT $? 0 0 "nft list counter verification failed"

    # Test add_rule_counter: Add rule with named counter
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 80 counter name "test_counter" accept
    CHECK_RESULT $? 0 0 "nft add rule with counter failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" | grep -q "test_counter"
    CHECK_RESULT $? 0 0 "nft list rule counter verification failed"

    # Test add_map: Add named map for port forwarding
    nft add map inet "$TEST_TABLE" test_map '{ type inet_service: ipv4_addr; }'
    CHECK_RESULT $? 0 0 "nft add map failed"
    nft list table inet "$TEST_TABLE" | grep "test_map"
    CHECK_RESULT $? 0 0 "nft list map verification failed"

    # Test add_map_element: Add element to map
    nft add element inet "$TEST_TABLE" test_map '{ 80: 10.0.0.1 }'
    CHECK_RESULT $? 0 0 "nft add map element failed"
    nft list map inet "$TEST_TABLE" test_map 2>/dev/null | grep "10.0.0.1"
    CHECK_RESULT $? 0 0 "nft list map element verification failed"

    # Test list_all: List all table content
    nft list table inet "$TEST_TABLE" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list table failed"

    # Test count_rules: Count rules in chain
    rule_count=$(nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep -c "tcp dport")
    [ "$rule_count" -ge 2 ]
    CHECK_RESULT $? 0 0 "rule count verification failed"

    # Test delete_rule: Delete specific rule
    rule_handle=$(nft -a list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep "tcp dport 22" | awk '{print $NF}')
    [ -n "$rule_handle" ]
    CHECK_RESULT $? 0 0 "nft get rule handle failed"
    nft delete rule inet "$TEST_TABLE" "$TEST_CHAIN" handle "$rule_handle"
    CHECK_RESULT $? 0 0 "nft delete rule failed"
    ! nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep -q "tcp dport 22"
    CHECK_RESULT $? 0 0 "nft delete rule verification failed"

    # Test delete_table: Delete table
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