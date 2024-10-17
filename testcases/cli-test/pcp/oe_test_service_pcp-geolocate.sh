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
# @Date      :   2024/10/11
# @License   :   Mulan PSL v2
# @Desc      :   Test pcp-geolocate.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL pcp-geolocate
    log_time="$(date '+%Y-%m-%d %T')"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl status pcp-geolocate.service | grep "Active" | grep -v "inactive (dead)"
    CHECK_RESULT $? 0 1 "There is an error for the status of pcp-geolocate.service"
    test_enabled pcp-geolocate.service
    journalctl --since "${log_time}" -u pcp-geolocate.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|HTTPError\|/usr/lib64/python3.11/urllib/request\|self.parent.error"
    CHECK_RESULT $? 0 1 "There is an error message for the log of pcp-geolocate.service"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop pcp-geolocate.service
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
