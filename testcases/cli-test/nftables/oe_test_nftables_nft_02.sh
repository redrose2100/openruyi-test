#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/30
# @License   :   Mulan PSL v2
# @Desc      :   Verify nftables output and formatting options (-a, -L, -s, -t, -S, -N, -u, -n, -y, -p, -T, -e, -d)
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nftables"
    table_name="test_table_02"
    chain_name="test_chain_02"
    export table_name chain_name
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    nft add table inet "${table_name}" && nft list tables | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to add table"
    nft add chain inet "${table_name}" "${chain_name}" "{ type filter hook input priority 0 ; policy accept ; }" && nft list chains | grep "${chain_name}"
    CHECK_RESULT $? 0 0 "Failed to add chain"
    nft add rule inet "${table_name}" "${chain_name}" tcp dport 22 accept && nft list ruleset | grep "22"
    CHECK_RESULT $? 0 0 "Failed to add rule"
    nft -a list chain inet "${table_name}" "${chain_name}" | grep "handle"
    CHECK_RESULT $? 0 0 "Failed to show handles with -a option"
    nft -s list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -s stateless option"
    nft -t list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -t terse option"
    nft -S list ruleset | grep "ssh"
    CHECK_RESULT $? 0 0 "Failed to translate ports with -S option"
    nft -N list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -N reverse DNS option"
    nft -u list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -u GUID option"
    nft -n list ruleset | grep "22"
    CHECK_RESULT $? 0 0 "Failed to use -n numeric option"
    nft -y list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -y numeric priority option"
    nft -p list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -p numeric protocol option"
    nft -T list ruleset | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to use -T numeric time option"
    nft -e add rule inet "${table_name}" "${chain_name}" tcp dport 80 accept | grep "add rule"
    CHECK_RESULT $? 0 0 "Failed to echo with -e option"
    nft -d parser list ruleset | grep -E "parsing|table"
    CHECK_RESULT $? 0 0 "Failed to use -d debug option"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    nft delete table inet "${table_name}" 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
