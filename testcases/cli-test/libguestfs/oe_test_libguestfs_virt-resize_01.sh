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
# @Desc      :   verify the uasge of libguestfs virt-resize command
# ############################################
# shellcheck disable=SC2034

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    EXECUTE_T="240m"
    libguestfs_pre_test_no_install
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      OS_VERSION="24.03-LTS-SP1"
    else
      OS_VERSION="20.03-LTS-SP3"
    fi
    cp /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    qemu-img create -f qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2 50G
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    device=$(fdisk -l 2> /dev/null | grep "Device" -A 2 | grep -o "/dev/[a-z0-9]*" | awk 'NR==2')
    virt-resize --align-first never /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --align-first failed"
    virt-resize --alignment 128 /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --alignment failed"
    virt-resize --color /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --color failed"
    virt-resize -d /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize -d failed"
    virt-resize --delete "${device}" /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --delete failed"
    virt-resize -n /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize -n failed"
    virt-resize --expand "${device}" /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --expand failed"
    virt-resize --format qcow2 /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --format failed"
    virt-resize --help | grep 'virt-resize: resize a virtual'
    CHECK_RESULT $? 0 0 "Check virt-resize --help failed"
    virt-resize --ignore "${device}" /home/kvm/images/openEuler-"${OS_VERSION}".qcow2 /home/kvm/images/openEuler-"${OS_VERSION}"-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-resize --ignore failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test_resize "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
