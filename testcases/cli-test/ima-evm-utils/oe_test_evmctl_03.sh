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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test evmctl file operation and recursive options
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/ima-evm-utils/common/evmctl_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ima-evm-utils openssl"
    mkdir -p /tmp/ima_evm_test
    evmctl_gen_key /tmp/ima_evm_test
    CHECK_RESULT $? 0 0 "evmctl_gen_key failed to generate signing key and certificate"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test -a sha1: hash with SHA-1 algorithm
    echo "sha1 content" > /tmp/ima_evm_test/file_sha1.txt
    evmctl -a sha1 ima_hash /tmp/ima_evm_test/file_sha1.txt
    CHECK_RESULT $? 0 0 "evmctl -a sha1 ima_hash failed"

    # Test -a sha256: hash with SHA-256 algorithm
    echo "sha256 content" > /tmp/ima_evm_test/file_sha256.txt
    evmctl -a sha256 ima_hash /tmp/ima_evm_test/file_sha256.txt
    CHECK_RESULT $? 0 0 "evmctl -a sha256 ima_hash failed"

    # Test -a sha384: hash with SHA-384 algorithm
    echo "sha384 content" > /tmp/ima_evm_test/file_sha384.txt
    evmctl -a sha384 ima_hash /tmp/ima_evm_test/file_sha384.txt
    CHECK_RESULT $? 0 0 "evmctl -a sha384 ima_hash failed"

    # Test -a sha512: hash with SHA-512 algorithm
    echo "sha512 content" > /tmp/ima_evm_test/file_sha512.txt
    evmctl -a sha512 ima_hash /tmp/ima_evm_test/file_sha512.txt
    CHECK_RESULT $? 0 0 "evmctl -a sha512 ima_hash failed"

    # Test -a sm3: hash with SM3 algorithm (openEuler-specific patch)
    echo "sm3 content" > /tmp/ima_evm_test/file_sm3.txt
    evmctl -a sm3 ima_hash /tmp/ima_evm_test/file_sm3.txt
    CHECK_RESULT $? 0 0 "evmctl -a sm3 ima_hash failed"

    # Test -f (--sigfile): write IMA signature to a separate .sig file
    echo "sigfile content" > /tmp/ima_evm_test/file_sigfile.txt
    evmctl -f ima_sign --key /tmp/ima_evm_test/privkey.pem /tmp/ima_evm_test/file_sigfile.txt
    CHECK_RESULT $? 0 0 "evmctl -f ima_sign failed"
    test -f /tmp/ima_evm_test/file_sigfile.txt.sig
    CHECK_RESULT $? 0 0 "evmctl -f did not create .sig file"

    # Test -n: print result to stdout instead of setting xattr
    echo "stdout content" > /tmp/ima_evm_test/file_stdout.txt
    evmctl -n ima_hash /tmp/ima_evm_test/file_stdout.txt > /tmp/ima_evm_test/stdout_out.txt 2>&1
    CHECK_RESULT $? 0 0 "evmctl -n ima_hash failed"
    grep -E "[0-9a-f]{2}" /tmp/ima_evm_test/stdout_out.txt
    CHECK_RESULT $? 0 0 "evmctl -n did not print hex hash to stdout"

    # Test -v (verbose): ima_hash with verbose output
    echo "verbose content" > /tmp/ima_evm_test/file_verbose.txt
    evmctl -v ima_hash /tmp/ima_evm_test/file_verbose.txt > /tmp/ima_evm_test/verbose_out.txt 2>&1
    CHECK_RESULT $? 0 0 "evmctl -v ima_hash failed"
    grep -E "[0-9a-f]{2}" /tmp/ima_evm_test/verbose_out.txt
    CHECK_RESULT $? 0 0 "evmctl -v did not output hex digest"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/ima_evm_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
