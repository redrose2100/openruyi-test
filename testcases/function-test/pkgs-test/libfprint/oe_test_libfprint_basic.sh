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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/20
# @License   :   Mulan PSL v2
# @Desc      :   Test libfprint package installation and basic functionality
# ############################################

# shellcheck disable=SC2119,SC2046
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libfprint libfprint-devel"
    if [ -d "/usr/include/libfprint-2" ];then
        libfprint="libfprint-2"
    else
        libfprint="libfprint"
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test if package is installed
    rpm -q libfprint
    CHECK_RESULT $? 0 0 "libfprint package not installed"
    # Test library version information
    ldconfig -p | grep "libfprint"
    CHECK_RESULT $? 0 0 "libfprint not in ldconfig"
    # Test if library file exists
    [ -f "/usr/lib64/${libfprint}.so" ] || [ -f "/usr/lib/${libfprint}.so" ]
    CHECK_RESULT $? 0 0 "libfprint library file not found"
    # Test if pkg-config file exists
    pkg-config --exists ${libfprint}
    CHECK_RESULT $? 0 0 "libfprint pkg-config not found"
    # Test pkg-config version information
    pkg-config --modversion ${libfprint} | grep "$(rpm -qa libfprint | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "libfprint pkg-config version check failed"
    # Test pkg-config cflags
    pkg-config --cflags ${libfprint} | grep "libfprint"
    CHECK_RESULT $? 0 0 "libfprint pkg-config cflags check failed"
    # Test pkg-config libs
    pkg-config --libs ${libfprint} | grep "fprint"
    CHECK_RESULT $? 0 0 "libfprint pkg-config libs check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"