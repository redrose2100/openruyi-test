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
# @Desc      :   verify the uasge of libguestfs guestfish command
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
    guestfish --pipe-error -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --pipe-error failed"
    guestfish --progress-bars -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --progress-bars failed"
    guestfish --no-progress-bars -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --no-progress-bars failed"
    guestfish --selinux -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --selinux failed"
    guestfish --ro -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --ro failed"
    guestfish -v -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish -v failed"
    guestfish -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check guestfish -V failed"
    guestfish --rw -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish --rw failed"
    guestfish -x -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 -i cat /etc/group
    CHECK_RESULT $? 0 0 "Check guestfish -x failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
