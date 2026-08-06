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
# @Desc      :   Test nftables basic table operations: table, chain, rule, set, counter, map
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_TABLE="libnftnl_table"
TEST_CHAIN="libnftnl_table_chain"
TEST_FILE="/tmp/libnftnl_test_rules.nft"

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
    nft list tables | grep "$TEST_TABLE"
    CHECK_RESULT $? 0 0 "nft list table verification failed"

    # Test add_chain: Create chain in table
    nft add chain inet "$TEST_TABLE" "$TEST_CHAIN" "{ type filter hook input priority 0 ; policy accept ; }"
    CHECK_RESULT $? 0 0 "nft add chain failed"
    nft list chains | grep "$TEST_CHAIN"
    CHECK_RESULT $? 0 0 "nft list chain verification failed"

    # Test add_rule: Add rule to chain
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport 22 accept
    CHECK_RESULT $? 0 0 "nft add rule failed"
    nft list table inet "$TEST_TABLE" | grep "22"
    CHECK_RESULT $? 0 0 "nft list rule verification failed"

    # Test add_rule_set: Add rule with anonymous set
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" tcp dport "{ 80, 443 }" accept
    CHECK_RESULT $? 0 0 "nft add rule with set failed"
    nft list table inet "$TEST_TABLE" | grep -E "80.*443|443.*80"
    CHECK_RESULT $? 0 0 "nft list rule set verification failed"

    # Test list_table: List specific table
    nft list table inet "$TEST_TABLE" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list table failed"

    # Test list_chains: List chains
    nft list chains > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list chains failed"

    # Test add_named_set: Create named set
    nft add set inet "$TEST_TABLE" test_set '{ type ipv4_addr; }'
    CHECK_RESULT $? 0 0 "nft add set failed"
    nft list set inet "$TEST_TABLE" test_set > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list set verification failed"

    # Test add_set_element: Add element to set
    nft add element inet "$TEST_TABLE" test_set '{ 192.168.1.1 }'
    CHECK_RESULT $? 0 0 "nft add element failed"
    nft list set inet "$TEST_TABLE" test_set | grep "192.168.1.1"
    CHECK_RESULT $? 0 0 "nft list element verification failed"

    # Test add_counter: Create counter
    nft add counter inet "$TEST_TABLE" test_counter
    CHECK_RESULT $? 0 0 "nft add counter failed"
    nft list counter inet "$TEST_TABLE" test_counter > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list counter verification failed"

    # Test add_rule_counter: Add rule with anonymous counter
    nft add rule inet "$TEST_TABLE" "$TEST_CHAIN" counter tcp dport 80 accept
    CHECK_RESULT $? 0 0 "nft add rule with counter failed"
    nft list table inet "$TEST_TABLE" | grep -c "counter"
    CHECK_RESULT $? 0 0 "nft list rule counter verification failed"

    # Test add_map: Create map
    nft add map inet "$TEST_TABLE" test_map '{ type ipv4_addr: ipv4_addr; }'
    CHECK_RESULT $? 0 0 "nft add map failed"
    nft list map inet "$TEST_TABLE" test_map > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "nft list map verification failed"

    # Test add_map_element: Add element to map
    nft add element inet "$TEST_TABLE" test_map '{ 10.0.0.1: 192.168.1.1 }'
    CHECK_RESULT $? 0 0 "nft add map element failed"
    nft list map inet "$TEST_TABLE" test_map | grep "10.0.0.1"
    CHECK_RESULT $? 0 0 "nft list map element verification failed"

    # Test file_import: Import rules from file
    cat > "$TEST_FILE" << NFTEOF
table inet ${TEST_TABLE}_import {
    chain test_chain {
        type filter hook input priority 0
        policy accept
        tcp dport 8080 accept
    }
}
NFTEOF
    nft -f "$TEST_FILE"
    CHECK_RESULT $? 0 0 "nft import from file failed"
    nft list tables | grep "${TEST_TABLE}_import"
    CHECK_RESULT $? 0 0 "nft list import table verification failed"

    # Test delete_rule: Delete specific rule
    rule_handle=$(nft -a list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep "tcp dport 22" | awk '{print $NF}')
    [ -n "$rule_handle" ]
    CHECK_RESULT $? 0 0 "nft get delete handle failed"
    nft delete rule inet "$TEST_TABLE" "$TEST_CHAIN" handle "$rule_handle"
    CHECK_RESULT $? 0 0 "nft delete rule failed"
    nft list chain inet "$TEST_TABLE" "$TEST_CHAIN" 2>/dev/null | grep -q "tcp dport 22"
    [ $? -ne 0 ]
    CHECK_RESULT $? 0 0 "nft delete rule verification failed"

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
    nft delete table inet "${TEST_TABLE}_import" 2>/dev/null
    nft delete table inet "$TEST_TABLE" 2>/dev/null
    nft flush ruleset 2>/dev/null
    rm -f "$TEST_FILE"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
