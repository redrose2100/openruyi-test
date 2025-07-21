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
# @Desc      :   verify the uasge of libguestfish guestunmount command
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
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      OS_VERSION="24.03-LTS-SP1"
    else
      OS_VERSION="20.03-LTS-SP3"
    fi
    device=$( fdisk -l 2> /dev/null | grep "Device" -A 1 | grep -o "/dev/[a-z0-9]*") 
    guestunmount --help | grep 'guestunmount'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
    guestmount -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2" -m "$device" --ro /mnt
    guestunmount -q /mnt
    CHECK_RESULT $? 0 0 "Check guestunmount -q failed"
    guestmount -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2" -m "$device" --ro /mnt
    guestunmount --no-retry /mnt/
    CHECK_RESULT $? 0 0 "Check guestunmount --no-retry failed"
    guestmount -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2" -m "$device" --ro /mnt
    guestunmount --retry=5 /mnt/
    CHECK_RESULT $? 0 0 "Check guestunmount --retry failed"
    guestmount -a "/home/kvm/images/openEuler-${OS_VERSION}.qcow2" -m "$device" --ro /mnt
    guestunmount -v /mnt
    CHECK_RESULT $? 0 0 "Check guestunmount -v failed"
    guestunmount -V 2>&1 | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check guestunmount -V failed"

    LOG_INFO "End of the test."
}

function post_test() {
   LOG_INFO "Start to restore the test environment."
   libguestfs_post_test "$@"
   LOG_INFO "Finish to restore the test environment."
}

main "$@"
