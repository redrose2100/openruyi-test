#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2022/04/22
# @License   :   Mulan PSL v2
# @Desc      :   Firewall management ICMP requests-list and block ICMP requests
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    sudo systemctl start firewalld
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    icmp_types=$(sudo firewall-cmd --get-icmptypes)
    CHECK_RESULT $? 0 0 "firewall-cmd --get-icmptypes failed"
    [ -n "$icmp_types" ] || CHECK_RESULT 1 0 0 "get icmptypes returned empty"
    for line in $icmp_types; do
        sudo firewall-cmd --info-icmptype="${line}" | grep -E "ipv4|ipv6"
        CHECK_RESULT $?
        sudo firewall-cmd --query-icmp-block="${line}" | grep -E "yes|no"
        CHECK_RESULT $?
    done
    LOG_INFO "Finish testcase execution."
}

main "$@"
