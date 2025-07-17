#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   sunying
#@Contact   	:   sunying@nj.iscas.ac.cn
#@Date      	:   2023-03-07 09:35:05
#@License   	:   Mulan PSL v2
#@Desc      	:   Test kconfigDetector
#####################################
# shellcheck disable=SC2002,SC2010
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    srcpath="/tmp/testkconfig/linux"
    outpath="/tmp/testkconfig/checkresult"
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

    LOG_INFO "test check_kconfig_dep -h help"
    check_kconfig_dep -h | grep "<checkfile>"
    CHECK_RESULT $? 0 0 "check_kconfig_dep -h failed"

    # detect x86_64 config files
    LOG_INFO "test check_kconfig_dep testfile01.x86_64"
    check_kconfig_dep -c "${filepath}"/testfile01.x86_64 -v 5.10.0 -s "${srcpath}" -a x86 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile01.x86_64 failed"
    # output result
    ls "${outpath}/5.10.0-x86" | grep ".json"
    CHECK_RESULT $? 0 0 "check_kconfig_dep output x86 failed"

    LOG_INFO "test check_kconfig_dep testfile02.x86_64 with wrong value"
    check_kconfig_dep -c "${filepath}"/testfile02.x86_64 -v 5.10.0 -s "${srcpath}" -a x86 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 failed"
    # detect error type: depends error
    cat "${outpath}/5.10.0-x86/5.10.0_x86_error.json" | jq .JUMP_LABEL.error | grep "depends error"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [depends error] failed"
    # detect error type: range error
    cat "${outpath}/5.10.0-x86/5.10.0_x86_error.json" | jq .LOG_BUF_SHIFT.error | grep "range error"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [range error] failed"
    # detect error type: lack config
    cat "${outpath}/5.10.0-x86/5.10.0_x86_error.json" | jq .TEST_KCONFIGDETECTOR.error | grep "lack config"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [lack config] failed"
    # detect error type: unmet dependences
    cat "${outpath}/5.10.0-x86/5.10.0_x86_error.json" | jq .SOFTLOCKUP_DETECTOR.error | grep "unmet dependences"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [unmet dependences] failed"
    # detect error type: restrict warning
    cat "${outpath}/5.10.0-x86/5.10.0_x86_error.json" | jq .AMD_IOMMU_V2.error | grep "restrict warning"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [restrict warning] failed"

    # detect aarch64 config files
    LOG_INFO "test check_kconfig_dep testfile01.aarch64"
    check_kconfig_dep -c "${filepath}"/testfile01.aarch64 -v 5.10.0 -s "${srcpath}" -a arm64 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile01.aarch64 failed"
    # output result
    ls "${outpath}/5.10.0-arm64" | grep ".json"
    CHECK_RESULT $? 0 0 "check_kconfig_dep output aarch64 failed"

    LOG_INFO "test check_kconfig_dep testfile02.aarch64 with wrong value"
    check_kconfig_dep -c "${filepath}"/testfile02.aarch64 -v 5.10.0 -s "${srcpath}" -a arm64 -o "${outpath}" | grep "Check time"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 failed"
    # detect error type: depends error
    cat "${outpath}/5.10.0-arm64/5.10.0_arm64_error.json" | jq .NO_HZ_FULL.error | grep "depends error"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 [depends error] failed"
    # detect error type: range error
    cat "${outpath}/5.10.0-arm64/5.10.0_arm64_error.json" | jq .PRINTK_SAFE_LOG_BUF_SHIFT.error | grep "range error"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 [range error] failed"
    # detect error type: lack config
    cat "${outpath}/5.10.0-arm64/5.10.0_arm64_error.json" | jq .TEST_KCONFIGDETECTOR_AARCH64.error | grep "lack config"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 [lack config] failed"
    # detect error type: unmet dependences
    cat "${outpath}/5.10.0-arm64/5.10.0_arm64_error.json" | jq .GENERIC_CLOCKEVENTS_BROADCAST.error | grep "unmet dependences"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 [unmet dependences] failed"
    # detect error type: restrict warning
    cat "${outpath}/5.10.0-arm64/5.10.0_arm64_error.json" | jq .NETWORK_PHY_TIMESTAMPING.error | grep "restrict warning"
    CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 [restrict warning] failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE "$@"
    rm -rf "/tmp/testkconfig"

    LOG_INFO "End to restore the test environment."
}

main "$@"
