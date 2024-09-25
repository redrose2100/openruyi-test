#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/7/10
# @License   :   Mulan PSL v2
# @Desc      :   Test patch-tracking.service restart
# #############################################
#shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL patch-tracking
    openssl req -x509 -days 3650 -subj "/CN=self-signed" \
-nodes -newkey rsa:4096 -keyout self-signed.key -out self-signed.crt
    mv self-signed.key self-signed.crt /etc/patch-tracking
    mv /etc/patch-tracking/settings.conf /etc/patch-tracking/settings.conf_bak
    cp -r ./settings.conf /etc/patch-tracking/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution patch-tracking.service
    test_reload patch-tracking.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop patch-tracking.service
    rm -rf /etc/patch-tracking/elf-signed.key /etc/patch-tracking/self-signed.crt
    rm -rf /etc/patch-tracking/settings.conf 
    mv /etc/patch-tracking/settings.conf_bak /etc/patch-tracking/settings.conf
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

