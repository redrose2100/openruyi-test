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
# @Desc      :   Test isulad.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iSulad
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_restart isulad.service
    test_enabled isulad.service
    if [[ ${NODE1_FRAME} != "riscv64" ]]; then
        journalctl --since "${log_time}" -u isulad.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARN\|home\/lkp\/rpmbuild\/BUILD"
        CHECK_RESULT $? 0 1 "There is an error message for the log of isulad.service"
    fi
    systemctl start isulad.service
    sed -i 's\ExecStart=/usr/bin/isulad\ExecStart=/usr/bin/isulad --log-level=ERROR\g' /usr/lib/systemd/system/isulad.service
    systemctl daemon-reload
    systemctl reload isulad.service 2>&1 | grep "Job type reload is not applicable"
    CHECK_RESULT $? 0 0 "isulad.service reload failed"
    systemctl status isulad.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "isulad.service reload causes the service status to change"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i 's\ExecStart=/usr/bin/isulad --log-level=ERROR\ExecStart=/usr/bin/isulad\g' /usr/lib/systemd/system/isulad.service
    systemctl daemon-reload
    systemctl reload isulad.service
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
