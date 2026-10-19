#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Act route to add/delete/check
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    sysgw=$(route -n | grep "0.0.0.0" | head -n 1 | awk '{print $2}')
    new_route=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1-3).0
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    route add -net "${new_route}" netmask 255.255.255.0 gw "${sysgw}"
    CHECK_RESULT $? 0 0 "Add route failed."
    route -n | grep -q "${new_route}"
    CHECK_RESULT $? 0 0 "Check ${new_route} added failed."
    route del -net "${new_route}" netmask 255.255.255.0
    CHECK_RESULT $? 0 0 "Delete route failed."
    route -n | grep "${new_route}\s*${sysgw}"
    CHECK_RESULT $? 1 0 "Check ${new_route} deleted failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
