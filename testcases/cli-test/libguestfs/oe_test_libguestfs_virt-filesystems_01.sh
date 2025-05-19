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
# @Desc      :   verify the uasge of libguestfs virt-filesystems command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-filesystems -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"
    virt-filesystems --all -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --all failed"
    virt-filesystems --blkdevs -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --blkdevs failed"
    virt-filesystems -c test:///default -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems -c failed"
    virt-filesystems --csv -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --csv failed"
    virt-filesystems -d openEuler-2403
    CHECK_RESULT $? 0 0 "Check virt-filesystems -d failed"
    virt-filesystems --echo-keys -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --echo-keys failed"
    virt-filesystems --extra -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --extra failed"
    virt-filesystems --filesystems -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"
    virt-filesystems --format=qcow2 -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --format failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
