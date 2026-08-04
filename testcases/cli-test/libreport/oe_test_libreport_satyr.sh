#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   Verify libreport package installation and satyr basic functions
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libreport gcc gdb"
    test_dir="/tmp/libreport_test_$$"
    mkdir -p "${test_dir}"
    bash "common/libreport_prepare_test.sh" "${test_dir}"
    export test_dir
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q libreport | grep "libreport"
    CHECK_RESULT $? 0 0 "libreport package not installed"
    rpm -V libreport
    CHECK_RESULT $? 0 0 "libreport package verification failed"
    rpm -qa libreport | awk -F- '{print $2}' | grep -E '[0-9]+'
    CHECK_RESULT $? 0 0 "Failed to get libreport version"
    test -f /usr/bin/satyr
    CHECK_RESULT $? 0 0 "satyr binary missing"
    satyr --help | grep -E "Usage:|satyr"
    CHECK_RESULT $? 0 0 "Failed to show satyr help"
    satyr --version | grep -E "satyr|version"
    CHECK_RESULT $? 0 0 "Failed to show satyr version"
    satyr abrt-print-report-from-dir "${test_dir}" | grep -i "report\|problem\|crash"
    CHECK_RESULT $? 0 0 "Failed to test abrt-print-report-from-dir"
    satyr abrt-create-core-stacktrace "${test_dir}"
    CHECK_RESULT $? 0 0 "Failed to test abrt-create-core-stacktrace"
    test -s "${test_dir}/core_backtrace"
    CHECK_RESULT $? 0 0 "core_backtrace not generated"
    satyr debug normalize "${test_dir}/gdb_backtrace" | grep "main"
    CHECK_RESULT $? 0 0 "Failed to test debug normalize"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -rf "${test_dir}" 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
