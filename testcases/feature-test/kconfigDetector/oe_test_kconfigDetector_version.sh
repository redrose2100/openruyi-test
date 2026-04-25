#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author     :   2401_86190146
#@Contact    :   202422460152@mail.sdu.edu.cn
#@Date       :   2026-04-21
#@License    :   Mulan PSL v2
#@Desc       :   Test kconfigDetector with different kernel versions
#####################################
# shellcheck disable=SC2002,SC2010,SC2034
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="240m"
    srcpath="/tmp/testkconfig/linux"
    outpath="/tmp/testkconfig/checkresult_version"
    filepath="/tmp/testkconfig/check"
    mkdir -p "${srcpath}"
    mkdir -p "${outpath}"
    mkdir -p "${filepath}"
    # jq is used to parse the check result json file
    DNF_INSTALL "kconfigDetector jq git"
    if ! rpm -q kconfigDetector; then
        exit 255
    fi
    # download kernel sourcecode
    git clone --branch openEuler-22.09 --depth 1 https://gitee.com/openeuler/kernel "${srcpath}"
    # prepare config file to check
    cp -r testfile* "${filepath}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Check kconfigDetector version compatibility
    LOG_INFO "Test 1: Check kconfigDetector version compatibility"
    check_kconfig_dep --version | grep "version"
    CHECK_RESULT $? 0 0 "check_kconfig_dep --version failed"

    # Test 2: Test with different kernel versions
    LOG_INFO "Test 2: Test with different kernel versions"
    for version in "5.10.0" "5.10.1" "5.10.2"; do
        LOG_INFO "Testing with kernel version: ${version}"
        check_kconfig_dep -c "${filepath}"/testfile01.x86_64 -v "${version}" -s "${srcpath}" -a x86 -o "${outpath}" | grep "Check time"
        CHECK_RESULT $? 0 0 "check_kconfig_dep with version ${version} failed"
        # Check output file exists
        ls "${outpath}/${version}-x86" | grep ".json"
        CHECK_RESULT $? 0 0 "check_kconfig_dep output for version ${version} failed"
    done

    # Test 3: Test with custom config file
    LOG_INFO "Test 3: Test with custom config file"
    # Create a minimal custom config file
    cat >"${filepath}/custom_config.conf" <<EOF
CONFIG_X86_64=y
CONFIG_SMP=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT_NONE=y
EOF
    
    check_kconfig_dep -c "${filepath}/custom_config.conf" -v "5.10.0" -s "${srcpath}" -a x86 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep with custom config failed"
    # Check output file exists
    ls "${outpath}/5.10.0-x86" | grep ".json"
    CHECK_RESULT $? 0 0 "check_kconfig_dep output for custom config failed"

    # Test 4: Test error handling with invalid config file
    LOG_INFO "Test 4: Test error handling with invalid config file"
    # Create an invalid config file
    cat >"${filepath}/invalid_config.conf" <<EOF
CONFIG_X86_64=y
CONFIG_INVALID_OPTION=y
EOF
    
    check_kconfig_dep -c "${filepath}/invalid_config.conf" -v "5.10.0" -s "${srcpath}" -a x86 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep with invalid config failed"
    # Check error file exists
    ls "${outpath}/5.10.0-x86" | grep "_error.json"
    CHECK_RESULT $? 0 0 "check_kconfig_dep error output for invalid config failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE "$@"
    rm -rf "/tmp/testkconfig"

    LOG_INFO "End to restore the test environment."
}

main "$@"
