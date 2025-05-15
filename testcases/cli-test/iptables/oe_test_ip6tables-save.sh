#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of ip6tables-save
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iptables
    ip6tables-save > iptables_rules.v6
    LOG_INFO "End to prepare the test environment."
}
	
function run_test() {
    LOG_INFO "Start to run test."
    ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
    ip6tables-save | grep "dport 80"
    CHECK_RESULT $? 0 0 "Rule added successfully"
    ip6tables-restore < iptables_rules.v6
    ip6tables-save | grep -v "dport 80"
    CHECK_RESULT $? 0 0 "Rule recovery successful"
    ip6tables-save -t filter | grep filter
    CHECK_RESULT $? 0 0 "Failed to display filter"
    ip6tables-save -t filter | grep -E "nat|mangle|raw|security"
    CHECK_RESULT $? 0 1 "Not just filter"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -f iptables_rules.v6
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
