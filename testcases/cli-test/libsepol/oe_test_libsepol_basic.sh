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
# @Date      :   2026/07/16
# @License   :   Mulan PSL v2
# @Desc      :   Test libsepol package installation and basic functionality
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libsepol libsepol-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test if package is installed
    rpm -q libsepol
    CHECK_RESULT $? 0 0 "libsepol package not installed"
    # Test version check
    rpm -q libsepol --qf "%{VERSION}\n"
    CHECK_RESULT $? 0 0 "libsepol version check failed"
    # Test if library file exists
    [ -f "/usr/lib64/libsepol.so" ] || [ -f "/usr/lib/libsepol.so" ]
    CHECK_RESULT $? 0 0 "libsepol library not found"
    # Test if header file exists
    [ -f "/usr/include/sepol/sepol.h" ]
    CHECK_RESULT $? 0 0 "libsepol header not found"
    if rpm -ql libsepol libsepol-devel | grep bin | grep sepol;then
        # Test if sepol_check_access command exists
        command -v sepol_check_access
        CHECK_RESULT $? 0 0 "sepol_check_access command not found"
        # Test if sepol_compute_av command exists
        command -v sepol_compute_av
        CHECK_RESULT $? 0 0 "sepol_compute_av command not found"
        # Test if sepol_compute_member command exists
        command -v sepol_compute_member
        CHECK_RESULT $? 0 0 "sepol_compute_member command not found"
        # Test if sepol_compute_relabel command exists
        command -v sepol_compute_relabel
        CHECK_RESULT $? 0 0 "sepol_compute_relabel command not found"
        # Test if sepol_validate_transition command exists
        command -v sepol_validate_transition
        CHECK_RESULT $? 0 0 "sepol_validate_transition command not found"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"