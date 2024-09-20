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
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/09/12
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of augeas
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL augeas
    echo "10.7.1.1 gate.com" > /tmp/mugen_tst_hosts
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    local conf options
    conf="/etc/hosts"
    options="-a -L -o"

    for i in $options; do
        augmatch "$i" "$conf"
	CHECK_RESULT $? 0 0 "augmatch $i $conf failed"
    done

    augmatch /etc/hosts -m "*/ipaddr" | grep -v "ipaddr"
    CHECK_RESULT $? 0 1 "augmatch -m get unmatched node(s)"

    augmatch -l Hosts /tmp/mugen_tst_hosts > /tmp/mugen_tst_hosts.out
    CHECK_RESULT $? 0 0 "augmatch transfer file with Hosts failed."

    grep "1/canonical = gate.com" /tmp/mugen_tst_hosts.out
    CHECK_RESULT $? 0 0 "Wrong output by augmatch, -l option doesn't work properly"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /tmp/mugen_tst_hosts /tmp/mugen_tst_hosts.out
    LOG_INFO "End to restore the test environment."
}

main "$@"
