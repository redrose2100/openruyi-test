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
# @Desc      :   verify the uasge of libguestfs guestmount command
# ############################################

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    device=$( fdisk -l 2> /dev/null | grep "Device" -A 1 | grep -o "/dev/[a-z0-9]*") 
    guestmount -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount -a -m --ro failed"
    guestunmount /mnt
    guestmount -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 --fd=1 -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount --fd failed"
    guestunmount /mnt
    guestmount -c test:///default -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount -c failed"
    guestunmount /mnt
    guestmount -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 --dir-cache-timeout 5 -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount --dir-cache-timeout failed"
    guestunmount /mnt
    guestmount -d openEuler-2003 -i --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount -d failed"
    guestunmount /mnt
    guestmount -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 --echo-keys -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount --echo-keys failed"
    guestunmount /mnt
    guestmount --format=qcow2 -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -m $device --ro /mnt
    CHECK_RESULT $? 0 0 "Check guestmount --format failed"
    guestunmount /mnt
    guestmount --fuse-help -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 -m $device --ro /mnt 2>&1 | grep 'usage: guestmount'
    CHECK_RESULT $? 0 0 "Check guestmount --fuse-help failed"
    guestmount --help | grep 'guestmount: FUSE module for libguestfs'
    CHECK_RESULT $? 0 0 "Check guestmount --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
