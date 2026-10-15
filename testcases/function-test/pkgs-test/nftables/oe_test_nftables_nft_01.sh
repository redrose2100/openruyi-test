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
# @Desc      :   Verify nftables package and basic options (-h, -v, -V, -c, -D, -o, -I)
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nftables"
    table_name="test_table_01"
    chain_name="test_chain_01"
    export table_name chain_name
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q nftables | grep "nftables"
    CHECK_RESULT $? 0 0 "nftables package not installed"
    rpm -V nftables
    CHECK_RESULT $? 0 0 "nftables package verification failed"
    nft --help | grep -E "Usage:|Options"
    CHECK_RESULT $? 0 0 "Failed to show help"
    nft --version | grep "$(rpm -q nftables | awk -F'-' '{print $2}')"
    CHECK_RESULT $? 0 0 "Failed to show version"
    nft -V | grep -E "nftables|version"
    CHECK_RESULT $? 0 0 "Failed to show extended version"
    nft add table inet "${table_name}" && nft list tables | grep "${table_name}"
    CHECK_RESULT $? 0 0 "Failed to add table"
    nft add chain inet "${table_name}" "${chain_name}" "{ type filter hook input priority 0 ; policy accept ; }" && nft list chains | grep "${chain_name}"
    CHECK_RESULT $? 0 0 "Failed to add chain"
    nft add rule inet "${table_name}" "${chain_name}" tcp dport 22 accept && nft list ruleset | grep "22"
    CHECK_RESULT $? 0 0 "Failed to add rule"
    nft -c -f <(echo "add rule inet ${table_name} ${chain_name} tcp dport 80 accept")
    CHECK_RESULT $? 0 0 "Failed to check rules with -c option"
    nft -D myvar=100 -f <(echo "add rule inet ${table_name} ${chain_name} tcp dport \$myvar accept") && nft list ruleset | grep "100"
    CHECK_RESULT $? 0 0 "Failed to define variable with -D option"
    nft -o -f <(echo "list ruleset") | grep -E "table|chain"
    CHECK_RESULT $? 0 0 "Failed to optimize ruleset with -o option"
    nft -I /etc/nftables -c -f <(echo "list ruleset")
    CHECK_RESULT $? 0 0 "Failed to use include path with -I option"
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
