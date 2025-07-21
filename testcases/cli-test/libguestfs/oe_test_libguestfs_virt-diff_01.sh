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
# @Desc      :   verify the uasge of libguestfs virt-diff command
# ############################################
# shellcheck disable=SC2034

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    EXECUTE_T="240m"
    libguestfs_pre_test
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        DNF_INSTALL "unzip"
        wget https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt -O debian_riscv.zip --no-check-certificate
        unzip -j debian_riscv.zip dqib_riscv64-virt/image.qcow2 -d /home/kvm/images/
        mv /home/kvm/images/image.qcow2 /home/kvm/images/debian-riscv.qcow2
        virt-install --name debian-riscv64 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/debian-riscv.qcow2,bus=virtio,format=qcow2 --virt-type qemu  --network=bridge:virbr0 --force --import --noautoconsole --graphics none --os-variant unknown
        virsh destroy debian-riscv64
        cp "/home/kvm/images/debian-riscv.qcow2" "/home/kvm/images/debian-riscv-1.qcow2"
        virt-install --name debian-riscv64-1 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/debian-riscv-1.qcow2,bus=virtio,format=qcow2 --virt-type qemu  --network=bridge:virbr0 --force --import --noautoconsole --graphics none --os-variant unknown
        virsh destroy debian-riscv64-1
        OS_NAME="debian-riscv"
    else
        cp "/home/kvm/images/openEuler-20.03-LTS-SP3.qcow2" "/home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2"
        virt-install --name openEuler-2003-1 --ram 2048 --vcpus=2 --disk path="/home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2",bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole --graphics none --os-variant unknown
        virsh destroy openEuler-2003-1
        OS_NAME="openEuler-20.03-LTS-SP3"
    fi
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-diff -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff -a -A failed"
    virt-diff --all -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff -d -D failed"
    virt-diff --atime -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff --atime failed"
    virt-diff --checksum=crc -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff --checksum failed"
    virt-diff -c test:///default -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff -c failed"
    virt-diff --csv -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff --csv failed"
    virt-diff --dir-links -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff --dir-links failed"
    virt-diff --dir-times -a "/home/kvm/images/${OS_NAME}.qcow2" -A "/home/kvm/images/${OS_NAME}-1.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-diff --dir-times failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test_diff "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
