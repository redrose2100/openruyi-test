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
# @Desc      :   verify the uasge of libguestfs virt-df command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      OS_VERSION="24.03-LTS-SP1"
      VIRT_NAME="openEuler-2403"
    else
      OS_VERSION="20.03-LTS-SP3"
      VIRT_NAME="openEuler-2003"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-df -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -a failed"
    virt-df -c test:///default -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -c failed"
    virt-df --csv -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df --csv failed"
    virt-df -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -d failed"
    virt-df --format=qcow2 -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df --format failed"
    virt-df -h "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -h failed"
    virt-df -i "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -i failed"
    virt-df --one-per-guest "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df --one-per-guest failed"
    virt-df -P 2 "/home/kvm/images/openEuler-${OS_VERSION}.qcow2"
    CHECK_RESULT $? 0 0 "Check virt-df virt-df -P failed"
    virt-df --help 2>&1 | grep 'virt-df'
    CHECK_RESULT $? 0 0 "Check virt-df virt-df --help failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
