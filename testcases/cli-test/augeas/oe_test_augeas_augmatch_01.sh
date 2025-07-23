#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/07/23
# @License   :   Mulan PSL v2
# @Desc      :   test augprint
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "augeas augeas-libs"
    echo -e "nameserver 8.8.8.8\nsearch example.com" > /tmp/test_resolv.conf
    echo -e "/home client1(rw)\n/var client2(ro)" > /tmp/test_exports
    echo -e "127.0.0.1 localhost" > /tmp/test_hosts
    mkdir -p /tmp/augeas_test/etc
    cp /etc/hosts /tmp/augeas_test/etc/
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    augmatch -l Hosts /tmp/test_hosts | grep -q "127.0.0.1"
    CHECK_RESULT $? 0 0 "Hosts file parsing failed"
    augmatch -l Resolv /tmp/test_resolv.conf | grep -q "8.8.8.8"
    CHECK_RESULT $? 0 0 "Resolv file parsing with lens failed"
    augmatch -l Resolv -m 'nameserver[1]' /tmp/test_resolv.conf | grep -q "8.8.8.8"
    CHECK_RESULT $? 0 0 "Match option test failed"
    augmatch -l Exports -eom 'dir["/home"]/client' /tmp/test_exports | grep -q "client1"
    CHECK_RESULT $? 0 0 "Combined options test failed"
    augmatch /nonexistent_file 2>&1 | grep -q -E "Lens not found|can not determine lens"
    CHECK_RESULT $? 0 0 "Error handling failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf /tmp/test_resolv.conf /tmp/test_exports /tmp/test_hosts /tmp/augeas_test
    DNF_REMOVE "augeas augeas-libs"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

