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
# @Date      :   2026/07/22
# @License   :   Mulan PSL v2
# @Desc      :   Test ldns package installation and command availability
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ldns ldns-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify library and devel packages are installed
    rpm -q ldns ldns-devel
    CHECK_RESULT $? 0 0 "ldns packages are not installed"

    # Cross-check version between rpm metadata and pkg-config
    rpm_version=$(rpm -q ldns --qf '%{VERSION}')
    CHECK_RESULT $? 0 0 "failed to get ldns rpm version"
    pkg_version=$(pkg-config --modversion ldns)
    CHECK_RESULT $? 0 0 "failed to get ldns pkg-config version"
    [ "${rpm_version}" = "${pkg_version}" ]
    CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"

    # Verify ldns-version output matches rpm version
    ldns-version | grep -q "${rpm_version}"
    CHECK_RESULT $? 0 0 "ldns-version does not report the expected version"

    # Verify all major command-line tools are available
    for command_name in drill ldnsd ldns-keygen ldns-signzone ldns-verify-zone \
        ldns-read-zone ldns-compare-zones ldns-nsec3-hash ldns-mx ldns-resolver \
        ldns-key2ds ldns-rrsig ldns-dane ldns-notify ldns-update ldns-test-edns \
        ldns-testns ldns-dpa ldns-gen-zone ldns-zsplit ldns-zcat ldns-chaos \
        ldns-config ldns-keyfetcher ldns-revoke ldns-walk; do
        command -v "${command_name}"
        CHECK_RESULT $? 0 0 "${command_name} command is not available"
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
