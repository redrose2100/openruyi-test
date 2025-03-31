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
# @Desc      :   Test dnssec-triggerd.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL dnssec-trigger
    setenforce 0
    sed -i 's/control-enable.*/control-enable:yes\ncontrol-use-cert:"no"/g' /etc/unbound/unbound.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    log_time="$(date '+%Y-%m-%d %T')"
    test_restart dnssec-triggerd.service
    test_enabled dnssec-triggerd.service
    journalctl --since "${log_time}" -u dnssec-triggerd.service | grep -i "fail\|error" | grep -vE -i "DEBUG\|INFO\|WARNING|error: http_probe_create_get: Network is unreachable|error: could not UDP send to ip|error: could not send queries for probe"
    CHECK_RESULT $? 0 1 "There is an error message for the log of dnssec-triggerd.service"
    test_reload dnssec-triggerd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    setenforce 1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
