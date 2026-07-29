#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-27
# @License   :   Mulan PSL v2
# @Desc      :   libwebp package installation verification
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp libwebp-tools libwebp-devel libwebp-java"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Verify libwebp main package is installed
    rpm -qa | grep -w libwebp | grep -v tools | grep -v devel | grep -v java
    CHECK_RESULT $? 0 0 "libwebp main package not installed"

    # Step 2: Verify libwebp-tools package is installed
    rpm -qa | grep -w libwebp-tools
    CHECK_RESULT $? 0 0 "libwebp-tools package not installed"

    # Step 3: Verify libwebp-devel package is installed
    rpm -qa | grep -w libwebp-devel
    CHECK_RESULT $? 0 0 "libwebp-devel package not installed"

    # Step 4: Verify libwebp-java package is installed
    rpm -qa | grep -w libwebp-java
    CHECK_RESULT $? 0 0 "libwebp-java package not installed"

    # Step 5: Verify libwebp.so library file exists
    find /usr/lib64/ -name "libwebp.so*" | head -1
    CHECK_RESULT $? 0 0 "libwebp.so library not found"

    # Step 6: Verify pkg-config can find libwebp module and get version
    pkg-config --modversion libwebp
    CHECK_RESULT $? 0 0 "pkg-config libwebp module not found"

    # Step 7: Verify libwebp.pc file exists
    ls /usr/lib64/pkgconfig/libwebp.pc
    CHECK_RESULT $? 0 0 "libwebp.pc file not found"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"