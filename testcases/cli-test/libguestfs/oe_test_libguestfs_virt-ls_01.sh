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
# @Desc      :   verify the uasge of libguestfs virt-ls command
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

    virt-ls --format=qcow2 -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc
    CHECK_RESULT $? 0 0 "Check virt-ls -a failed"
    device=$( fdisk -l 2> /dev/null | grep "Device" -A 1 | grep -o "/dev/[a-z0-9]*") 
    virt-ls -m $device -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /
    CHECK_RESULT $? 0 0 "Check virt-ls -m failed"
    virt-ls -lR -d openEuler-2003 --checksum=md5 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"
    virt-ls -c test:///default -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc
    CHECK_RESULT $? 0 0 "Check virt-ls -c failed"
    virt-ls --csv -lR -d openEuler-2003 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --csv failed"
    virt-ls -d openEuler-2003 /etc
    CHECK_RESULT $? 0 0 "Check virt-ls -d failed"
    virt-ls -lR -d openEuler-2003 --echo-keys /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --echo-keys failed"
    virt-ls -lR --extra-stats -d openEuler-2003 /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --extra-stats failed"
    virt-ls --format=qcow2 -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc
    CHECK_RESULT $? 0 0 "Check virt-ls --format failed"
    virt-ls --help | grep 'virt-ls: list'
    CHECK_RESULT $? 0 0 "Check virt-ls --help failed"
    virt-ls -h -lR -d openEuler-2003 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls -h failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
