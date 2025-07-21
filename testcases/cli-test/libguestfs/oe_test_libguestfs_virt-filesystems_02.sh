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
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      OS_VERSION="24.03-LTS-SP1"
    else
      OS_VERSION="20.03-LTS-SP3"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-filesystems --long -h --all -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems -h failed"
    virt-filesystems --help 2>&1 | grep 'virt-filesystems'
    CHECK_RESULT $? 0 0 "Check virt-filesystems --help failed"
    virt-filesystems --keys-from-stdin -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --keys-from-stdin failed"
    virt-filesystems --long -h --all -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --long failed"
    virt-filesystems --lvs -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --lvs failed"
    virt-filesystems --no-title -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --no-title failed"
    virt-filesystems --parts -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --parts failed"
    virt-filesystems --pvs -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --pvs failed"
    virt-filesystems --uuid -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems --uuid failed"
    virt-filesystems -v -a /home/kvm/images/openEuler-"${OS_VERSION}".qcow2
    CHECK_RESULT $? 0 0 "Check virt-filesystems -v failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
