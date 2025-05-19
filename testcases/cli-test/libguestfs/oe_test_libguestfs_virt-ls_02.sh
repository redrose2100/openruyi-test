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
    virt-ls --key ID:key:KEY_STRING -lR -d openEuler-2403 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --key failed"
    virt-ls --keys-from-stdin -lR -d openEuler-2403 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --keys-from-stdin failed"
    virt-ls -l -lR -d openEuler-2003 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"
    virt-ls -R -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls -R failed"
    virt-ls -lR --times -d openEuler-2403 /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --times failed"
    virt-ls -lR -d openEuler-2403 --time-days /etc/ | awk '$6 <= 7'
    CHECK_RESULT $? 0 0 "Check virt-ls --time-days failed"
    virt-ls -lR --time-relative -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls --time-relative failed"
    virt-ls -lR --time-t -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls -time-t failed"
    virt-ls -lR --uids -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls --uids failed"
    virt-ls -v -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls -v failed"
    virt-ls -V | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check virt-ls -V failed"
    virt-ls -x -d openEuler-2403 /etc/
    CHECK_RESULT $? 0 0 "Check virt-ls -x failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
