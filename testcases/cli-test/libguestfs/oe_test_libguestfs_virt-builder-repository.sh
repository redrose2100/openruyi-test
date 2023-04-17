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
# @Desc      :   verify the uasge of libguestfs virt-builder-repository command
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
    virt-builder-repository --color --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --color failed"
    virt-builder-repository --gpg /root/ --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --gpg failed"
    virt-builder-repository --help 2>&1 | grep 'virt-builder-repository'
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --help failed"
    virt-builder-repository --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --machine-readable failed"
    virt-builder-repository --no-compression --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --no-compression failed"
    virt-builder-repository -q --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository -q failed"
    virt-builder-repository -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-builder-repository -V failed"
    virt-builder-repository -v --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository -v failed"
    virt-builder-repository -x --machine-readable
    CHECK_RESULT $? 0 0 "Check virt-builder-repository -x failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
