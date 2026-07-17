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
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-13
# @License   :   Mulan PSL v2
# @Desc      :   alsa-lib install verification and version check
# ############################################
# shellcheck disable=SC1090,SC2119,SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-lib alsa-lib-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Verify alsa-lib package is installed
    rpm -qa | grep -w alsa-lib
    CHECK_RESULT $? 0 0 "alsa-lib package not installed"
    
    # Step 2: Verify alsa-lib-devel package is installed
    rpm -qa | grep alsa-lib-devel
    CHECK_RESULT $? 0 0 "alsa-lib-devel package not installed"
    
    # Step 3: Verify pkg-config can find alsa module and get version
    pkg-config --modversion alsa
    CHECK_RESULT $? 0 0 "pkg-config alsa module not found"
    
    # Step 4: Verify libasound.so library file exists
	find /usr/lib64/ -name "libasound.so*" | grep -q .
    CHECK_RESULT $? 0 0 "libasound.so not found"
    
    # Step 5: Verify asoundlib.h header file exists
    ls /usr/include/alsa/asoundlib.h
    CHECK_RESULT $? 0 0 "asoundlib.h header not found"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
