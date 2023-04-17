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

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    export LIBGUESTFS_BACKEND=direct
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    virt-rescue -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-rescue -a failed"
    virt-rescue -d openEuler-2003 -i
    CHECK_RESULT $? 0 0 "Check virt-rescue -d failed"
    virt-rescue --append --blocksize=512 -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-rescue --append --blocksize failed"
    virt-rescue -e ^x -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-rescue -e failed"
    virt-rescue --format=raw -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-rescue --format failed"
    virt-rescue --help
    CHECK_RESULT $? 0 0 "Check virt-rescue --help failed"
    virt-rescue -d openEuler-2003 -i
    CHECK_RESULT $? 0 0 "Check virt-rescue -i failed"
    device=$( fdisk -l 2> /dev/null | grep "Device" -A 1 | grep -o "/dev/[a-z0-9]*")
    virt-rescue -m $device:/:acl,user_xattr -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-rescue -m failed"
    virt-rescue --memsize 256 -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-rescue --memsize failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
