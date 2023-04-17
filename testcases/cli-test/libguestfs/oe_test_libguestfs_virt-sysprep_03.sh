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

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    echo "hello" >a.txt
    virt-copy-in -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 a.txt /etc
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-sysprep --keys-from-stdin -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --keys-from-stdin failed"
    virt-sysprep --list-operations -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --list-operations failed"
    virt-sysprep --mkdir /etc/dir -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --mkdir failed"
    virt-sysprep --mount-options /mnt -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --mount-options failed"
    virt-sysprep -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 --move /etc/a.txt:/opt
    CHECK_RESULT $? 0 0 "Check virt-sysprep --move failed"
    virt-sysprep --no-logfile -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
    virt-sysprep --no-network -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-sysprep --no-network failed"
    virt-sysprep --no-selinux-relabel -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --no-selinux-relabel failed"
    virt-sysprep --operation ssh-hostkeys -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --operation failed"
    virt-sysprep --password root:password -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
