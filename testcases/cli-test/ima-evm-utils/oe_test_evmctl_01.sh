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
# @Desc      :   Test evmctl installation, version and basic IMA/EVM functionality
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/ima-evm-utils/common/evmctl_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ima-evm-utils openssl"
    mkdir -p /tmp/ima_evm_test
    evmctl_gen_key /tmp/ima_evm_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/ima_evm_test || exit 1

    # Verify package is installed
    rpm -q ima-evm-utils
    CHECK_RESULT $? 0 0 "ima-evm-utils package is not installed"

    # Verify version matches rpm metadata
    pkg_version=$(rpm -q ima-evm-utils --qf '%{VERSION}')
    evmctl --version 2>&1 | grep "${pkg_version}"
    CHECK_RESULT $? 0 0 "evmctl --version does not match rpm version"

    # Verify --help output shows usage
    evmctl --help 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "evmctl --help does not show usage"

    # Test basic ima_hash: calculate and set IMA hash on a file
    echo "ima hash test content" > hashfile.txt
    evmctl ima_hash hashfile.txt
    CHECK_RESULT $? 0 0 "evmctl ima_hash failed to set IMA hash"

    # Test basic ima_sign: sign file with RSA private key
    echo "ima sign test content" > signfile.txt
    evmctl ima_sign --key /tmp/ima_evm_test/privkey.pem signfile.txt
    CHECK_RESULT $? 0 0 "evmctl ima_sign failed to sign file"

    # Test basic ima_verify: verify IMA signature on signed file
    evmctl ima_verify --key /tmp/ima_evm_test/x509_evm.der signfile.txt
    CHECK_RESULT $? 0 0 "evmctl ima_verify failed to verify signed file"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/ima_evm_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
