#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2023/03/02
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs libguestfs-test-tool command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    export LIBGUESTFS_BACKEND=direct
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    libguestfs-test-tool --help 2>&1 | grep 'libguestfs-test-tool'
    CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --help failed"
    libguestfs-test-tool --qemu /usr/bin/qemu-kvm 2>&1 | grep 'TEST FINISHED OK'
    CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --qemu failed"
    libguestfs-test-tool -t 100 2>&1 | grep 'TEST FINISHED OK'
    CHECK_RESULT $? 0 0 "Check libguestfs-test-tool -t failed"
    libguestfs-test-tool --version 2>&1 | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --version failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
