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

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    cp /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    virt-install --name openEuler-2003-1 --ram 2048 --vcpus=2 --disk path=/home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2,bus=virtio,format=qcow2 --network=bridge:virbr0 --force --import --autostart --noautoconsole --graphics none --os-variant unknown
    virsh destroy openEuler-2003-1
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-diff --time-relative -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-diff --time-relative failed"
    virt-diff --time-t -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-diff --time-t failed"
    virt-diff --uids -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-diff --uids failed"
    virt-diff -v -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-diff -v failed"
    virt-diff -V 2>&1 | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check virt-diff -V failed"
    virt-diff -x -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-diff -x failed"
    virt-diff --xattrs -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -A /home/kvm/images/openEuler-20.03-LTS-SP3-1.qcow2
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test_diff "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
