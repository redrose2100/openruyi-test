#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/29
# @License   :   Mulan PSL v2
# @Desc      :   Test as10k1 command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_DIR="/tmp/as10k1_test_$(date +%s)"
    TEST_ASM="${TEST_DIR}/test.asm"
    TEST_LIST="${TEST_DIR}/test.list"
    TEST_OUT="${TEST_DIR}/test.emu10k1"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools"
    mkdir -p "${TEST_DIR}"
    cat > "${TEST_ASM}" << 'EOF'
; Test assembly file for as10k1
; Define GPRs
temp dyn 1
one con 2147483647
zero con 0
; Main code
    macs temp,one,one,one
    acc3 temp,temp,zero,zero
    macw temp,one,one,one
    end
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -h option
    as10k1 -h | grep -i "usage"
    CHECK_RESULT $? 0 0 "as10k1 -h check failed"
    # Test -v option
    as10k1 -v | grep -i "version"
    CHECK_RESULT $? 0 0 "as10k1 -v check failed"
    # Test -o option: generate output file
    as10k1 -o "${TEST_OUT}" "${TEST_ASM}"
    test -f "${TEST_OUT}"
    CHECK_RESULT $? 0 0 "as10k1 -o option check failed"
    # Test -l option: generate listing file
    as10k1 -l "${TEST_LIST}" "${TEST_ASM}"
    test -f "${TEST_LIST}"
    CHECK_RESULT $? 0 0 "as10k1 -l option check failed"
    # Test -d s option: print symbols
    as10k1 -d s "${TEST_ASM}" | grep -i "symbols"
    CHECK_RESULT $? 0 0 "as10k1 -d s option check failed"
    # Test -d g option: print GPRs
    as10k1 -d g "${TEST_ASM}" | grep -i "gprs"
    CHECK_RESULT $? 0 0 "as10k1 -d g option check failed"
    # Test -d t option: print TRAM usage
    as10k1 -d t "${TEST_ASM}" | grep -i "tram"
    CHECK_RESULT $? 0 0 "as10k1 -d t option check failed"
    # Test -d i option: print instructions
    as10k1 -d i "${TEST_ASM}" | grep -i "instructions"
    CHECK_RESULT $? 0 0 "as10k1 -d i option check failed"
    # Test -d with multiple debug flags
    as10k1 -d sgti "${TEST_ASM}" | grep -iE "symbols|gprs|tram|instructions"
    CHECK_RESULT $? 0 0 "as10k1 -d sgti option check failed"
    # Test with nonexistent file (expected to fail)
    as10k1 "/nonexistent/file.asm"
    CHECK_RESULT $? 0 1 "as10k1 should fail with nonexistent file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
