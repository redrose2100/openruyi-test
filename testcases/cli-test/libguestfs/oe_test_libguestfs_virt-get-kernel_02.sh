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
# @Desc      :   verify the uasge of libguestfs virt-get-kernel command
# ############################################

source "${OET_PATH}"/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
      VIRT_NAME="openEuler-2403"
    else
      VIRT_NAME="openEuler-2003"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    virt-get-kernel -o /etc/ -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel -o failed"
    virt-get-kernel --prefix pre -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel --prefix failed"
    virt-get-kernel -q -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel -q failed"
    virt-get-kernel --unversioned-names -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel --unversioned-names failed"
    virt-get-kernel -V | grep "$(rpm -q libguestfs --queryformat '%{version}\n')" 2>&1
    CHECK_RESULT $? 0 0 "Check virt-get-kernel -V failed"
    virt-get-kernel -v -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel -v failed"
    virt-get-kernel -x -d "${VIRT_NAME}"
    CHECK_RESULT $? 0 0 "Check virt-get-kernel -x failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
