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
# @Desc      :   verify the uasge of libguestfs virt-copy-out command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    echo "hello" >a.txt
    virt-copy-in -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 a.txt /etc
    virt-copy-in -d openEuler-2403 a.txt /etc
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-copy-out -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 /etc/a.txt ./
    CHECK_RESULT $? 0 0 "Check virt-copy-out -a failed"
    virt-copy-out -d openEuler-2403 /etc/a.txt ./
    CHECK_RESULT $? 0 0 "Check virt-copy-out -d failed"
    virt-copy-out -h 2>&1 | grep 'display a list of commands'
    CHECK_RESULT $? 0 0 "Check virt-copy-out -h failed"
    virt-copy-out -V | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check virt-copy-out -V failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
