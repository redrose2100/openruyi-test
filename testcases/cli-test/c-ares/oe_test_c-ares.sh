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
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Test c-ares all subpackages installation integrity and version
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "c-ares c-ares-devel c-ares-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify all subpackages are installed
    rpm -q c-ares
    CHECK_RESULT $? 0 0 "c-ares runtime library package is not installed"
    rpm -q c-ares-devel
    CHECK_RESULT $? 0 0 "c-ares-devel package is not installed"
    rpm -q c-ares-utils
    CHECK_RESULT $? 0 0 "c-ares-utils package is not installed"

    # Cross-check version between rpm metadata and pkg-config
    pkg_version=$(rpm -q c-ares --qf '%{VERSION}')
    [ -n "${pkg_version}" ]
    CHECK_RESULT $? 0 0 "failed to get c-ares rpm version"
    pkg-config --modversion libcares | grep -F "${pkg_version}"
    CHECK_RESULT $? 0 0 "pkg-config version does not match rpm version"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
