#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test ip6tables-restore function
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iptables
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    ip6tables-restore --help &> ip6tables_help
    grep "Usage: ip6tables-restore" ip6tables_help
    CHECK_RESULT $? 0 0 "ip6tables-restore --help command exec fail"
    ip6tables-save > ip6tables_bak
    echo "*filter
-A INPUT -p icmp -j DROP
COMMIT" > ip6tables_rule
    ip6tables-restore -t ip6tables_rule
    CHECK_RESULT $? 0 0 "ip6tables-restore -t exec fail"
    ip6tables-restore -n ip6tables_rule
    ip6tables -nvL | grep -E "DROP\s+icmp|DROP\s+1"
    CHECK_RESULT $? 0 0 "ip6tables-restore -n exec fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    ip6tables-restore -n ip6tables_bak
    CHECK_RESULT $? 0 0 "Failed to restore environment"
    rm -fr ip6tables*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
