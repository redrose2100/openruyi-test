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
# @Author    :   2401_86190146
# @Contact   :   202422460152@mail.sdu.edu.cn
# @Date      :   2026-04-23
# @License   :   Mulan PSL v2
# @Desc      :   Test openscap command line tools
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "openscap scap-security-guide"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: oscap version command
    LOG_INFO "Test 1: Check oscap version"
    oscap --version 2>&1 | grep -q "OpenSCAP"
    CHECK_RESULT $? 0 0 "oscap --version failed"

    # Test 2: oscap --help command
    LOG_INFO "Test 2: Check oscap help"
    oscap --help 2>&1 | grep -q "Usage"
    CHECK_RESULT $? 0 0 "oscap --help failed"

    # Test 3: oscap --list-profiles
    LOG_INFO "Test 3: List available profiles"
    oscap xccdf eval --list-profiles /usr/share/xml/scap/ssg/content/ssg-openeuler2203-ds.xml 2>&1 | grep -q "profiles"
    CHECK_RESULT $? 0 0 "oscap --list-profiles failed"

    # Test 4: oscap info command
    LOG_INFO "Test 4: Check oscap info"
    oscap info /usr/share/xml/scap/scap-security-guide/content/ssg-openeuler7-ds.xml 2>&1 | grep -qi "document"
    CHECK_RESULT $? 0 0 "oscap info failed"

    # Test 5: oscap oval eval
    LOG_INFO "Test 5: OVAL evaluation"
    oscap oval eval --results /tmp/oval-results.xml /usr/share/xml/scap/oval/vendor/openscap/openscap-oval.xml 2>&1 | grep -q "oval"
    CHECK_RESULT $? 0 0 "oscap oval eval failed"

    # Test 6: oscap xccdf generate fix
    LOG_INFO "Test 6: Generate XCCDF fix"
    oscap xccdf generate fix --profile xccdf_org.ssgproject.content_profile_standard /usr/share/xml/scap/ssg/content/ssg-openeuler2203-ds.xml 2>&1 | grep -q "fix"
    CHECK_RESULT $? 0 0 "oscap xccdf generate fix failed"

    # Test 7: oscap xccdf generate report
    LOG_INFO "Test 7: Generate XCCDF report"
    oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard --results /tmp/xccdf-results.xml --report /tmp/xccdf-report.html /usr/share/xml/scap/ssg/content/ssg-openeuler2203-ds.xml 2>&1 || true
    test -f /tmp/xccdf-results.xml
    CHECK_RESULT $? 0 0 "oscap xccdf eval failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -f /tmp/oval-results.xml /tmp/xccdf-results.xml /tmp/xccdf-report.html
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
