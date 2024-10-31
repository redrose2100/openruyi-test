#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyangmei
# @Contact   :   liuyangmei@h-partners.com
# @Date      :   2024-10-31
# @License   :   Mulan PSL v2
# @Desc      :   Command test-sssd
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sssd-tools
    cp -ar /etc/sssd/sssd.conf /etc/sssd/sssd.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -q sssd-tools
    CHECK_RESULT $? 0 0 "check sssd-tools install"
    sed -i 's/^; //' /etc/sssd/sssd.conf
    systemctl is-active sssd || systemctl restart sssd
    CHECK_RESULT $? 0 0 "check sssd service running"
    for i in $(seq 10); do
        domain=$(sssctl domain-list)
        test -n "$domain" && break
        sleep 1
    done
    CHECK_RESULT "$i" 10 1 "check sssctl domain-list"
    sssctl domain-status "$domain"
    CHECK_RESULT $? 0 0 "check sssctl domain-status"
    sssctl config-check -c /etc/sssd/sssd.conf
    CHECK_RESULT $? 0 0 "check sssctl config-check"
    useradd sssduser
    CHECK_RESULT $? 0 0 "check user add"
    rm -rf /var/lib/sss/db/*
    systemctl restart sssd
    sssctl logs-remove
    CHECK_RESULT $? 0 0 "check sssctl logs-remove"
    sssctl logs-fetch sssd-test.log
    CHECK_RESULT $? 0 0 "check sssctl logs-fetch"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf sssduser
    rm -f sssd-test.log
    systemctl stop sssd
    mv -f /etc/sssd/sssd.conf.bak /etc/sssd/sssd.conf
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
