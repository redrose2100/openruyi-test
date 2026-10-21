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
# @Desc      :   Test sssd.service restart
# #############################################
# shellcheck disable=SC1091
source "common/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    openldap_server_pre
    openldap_client_pre
    DNF_INSTALL sssd
    service="sssd.service"
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_restart "${service}"
    test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|_sasl_plugin_load failed on sasl_canonuser_init\|ldapdb_canonuser_plug_init() failed"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    test_reload "${service}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop "${service}"
    DNF_REMOVE "$@"
    openldap_server_post
    openldap_client_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
