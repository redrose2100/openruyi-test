#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test arpwatch.service restart
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL arpwatch
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution arpwatch.service
    test_reload arpwatch.service
    systemctl start arpwatch.service
    test -f /var/lib/arpwatch/arp.dat
    CHECK_RESULT $? 0 0 "Check arpwatch data file failed"
    if ip link show | grep -q "eth0"; then
        arpwatch -i eth0
    else
        first_interface=$(ip link show | grep -v "lo" | awk -F: '$0 !~ "^ " {print $2}' | head -n 1 | tr -d ' ')
        arpwatch -i "$first_interface"
    fi
    CHECK_RESULT $? 0 0 "Check arpwatch interface monitoring failed"
    initial_size=$(stat -c %s /var/lib/arpwatch/arp.dat)
    ping -c 4 127.0.0.1
    current_size=$(stat -c %s /var/lib/arpwatch/arp.dat)
    test "$current_size" -ge "$initial_size"
    CHECK_RESULT $? 0 0 "Check arpwatch data recording failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
