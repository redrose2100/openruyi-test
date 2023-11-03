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
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2023/04/04
# @License   :   Mulan PSL v2
# @Desc      :   Test iptables-restore function
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iptables
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    iptables-restore --help &> iptables_help
    grep "Usage: iptables-restore" iptables_help
    CHECK_RESULT $? 0 0 "iptables-restore --help command exec fail"
    iptables-save > iptables_bak
    echo "*filter
-A INPUT -p icmp -j DROP
COMMIT" > iptables_rule
    iptables-restore -t iptables_rule
    CHECK_RESULT $? 0 0 "iptables-restore -t exec fail"
    iptables-restore -n iptables_rule
    iptables -nvL | grep "DROP       icmp"
    CHECK_RESULT $? 0 0 "iptables-restore -n exec fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    iptables-restore -n iptables_bak
    CHECK_RESULT $? 0 0 "Failed to restore environment"
    rm -fr iptables*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"