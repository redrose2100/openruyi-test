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
source "${OET_PATH}"/testcases/function-test/pkgs-test/ima-evm-utils/common/evmctl_common.sh

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

    # Test -r (recursive): ima_hash on a directory recursively
    mkdir -p /tmp/ima_evm_test/recdir/sub
    echo "file1" > /tmp/ima_evm_test/recdir/file1.txt
    echo "file2" > /tmp/ima_evm_test/recdir/file2.txt
    echo "file3" > /tmp/ima_evm_test/recdir/sub/file3.txt
    evmctl -r ima_hash /tmp/ima_evm_test/recdir
    CHECK_RESULT $? 0 0 "evmctl -r ima_hash failed on directory"

    # Test -t f (type filter): recursively process only regular files, skip symlinks
    mkdir -p /tmp/ima_evm_test/typedir
    echo "regular" > /tmp/ima_evm_test/typedir/regular.txt
    ln -sf regular.txt /tmp/ima_evm_test/typedir/link.txt
    evmctl -r -t f ima_hash /tmp/ima_evm_test/typedir
    CHECK_RESULT $? 0 0 "evmctl -r -t f ima_hash failed"

    # Test -o (--portable): create portable EVM signature (no fs uuid, no inode)
    # Portable sign requires security.ima xattr to be present, so ima_sign first
    echo "portable content" > /tmp/ima_evm_test/file_portable.txt
    evmctl ima_sign --key /tmp/ima_evm_test/privkey.pem /tmp/ima_evm_test/file_portable.txt
    CHECK_RESULT $? 0 0 "evmctl ima_sign failed to generate IMA signature for portable sign test"
    evmctl -o sign --key /tmp/ima_evm_test/privkey.pem /tmp/ima_evm_test/file_portable.txt
    CHECK_RESULT $? 0 0 "evmctl -o sign failed to create portable signature"

    # Test ima_setxattr: set IMA xattr on target from a separate signature file
    echo "setxattr content" > /tmp/ima_evm_test/file_setxattr.txt
    evmctl -f ima_sign --key /tmp/ima_evm_test/privkey.pem /tmp/ima_evm_test/file_setxattr.txt
    CHECK_RESULT $? 0 0 "evmctl -f ima_sign failed to generate signature for setxattr test"
    evmctl ima_setxattr --sigfile /tmp/ima_evm_test/file_setxattr.txt.sig /tmp/ima_evm_test/file_setxattr.txt
    CHECK_RESULT $? 0 0 "evmctl ima_setxattr failed to set xattr from sig file"

    # Test --xattr-user: store IMA xattr in user namespace (for testing)
    echo "xattr user content" > /tmp/ima_evm_test/file_xattruser.txt
    evmctl --xattr-user ima_hash /tmp/ima_evm_test/file_xattruser.txt
    CHECK_RESULT $? 0 0 "evmctl --xattr-user ima_hash failed"
    getfattr -m user -n user.ima /tmp/ima_evm_test/file_xattruser.txt 2>/dev/null | grep "user.ima"
    CHECK_RESULT $? 0 0 "evmctl --xattr-user did not set user.ima xattr"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/ima_evm_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
