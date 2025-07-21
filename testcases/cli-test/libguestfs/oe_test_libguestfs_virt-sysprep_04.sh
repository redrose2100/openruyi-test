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
# @Desc      :   verify the uasge of libguestfs virt-sysprep command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      OS_VERSION="24.03-LTS-SP1"
      VIRT_NAME="openEuler-2403"
    else
      OS_VERSION="20.03-LTS-SP3"
      VIRT_NAME="openEuler-2003"
    fi
    libguestfs_pre_test
    echo "hello" >a.txt
    virt-copy-in -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 a.txt /etc
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-sysprep --password root:password -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"
    virt-sysprep --password-crypto md5 -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --password-crypto failed"
    virt-sysprep -q -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep -q failed"
    virt-sysprep --root-password password -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --root-password failed"
    virt-sysprep --run-command cat -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep ---run-command failed"
    virt-sysprep --scriptdir /etc/tmp -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --scriptdir failed"
    virt-sysprep --scrub /etc/a.txt -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --scrub failed"
    virt-sysprep --selinux-relabel -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --selinux-relabel failed"
    virt-sysprep --timezone Europe/London -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --timezone failed"
    virt-sysprep --touch /etc/a.txt -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-sysprep --touch failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
