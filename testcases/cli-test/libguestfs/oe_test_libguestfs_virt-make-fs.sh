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
# @Desc      :   verify the uasge of libguestfs virt-make-fs command
# ############################################

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    mkdir test
    export LIBGUESTFS_BACKEND=direct
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    virt-make-fs --floppy ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --floppy failed"
    virt-make-fs --format=raw ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --format failed"
    virt-make-fs --help
    CHECK_RESULT $? 0 0 "Check virt-make-fs --help failed"
    virt-make-fs --label=label ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --label failed"
    virt-make-fs --partition ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --partition failed"
    virt-make-fs --format=qcow2 --size=+200M ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --size failed"
    virt-make-fs --format=qcow2 --type=ext4 --size=+200M ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs --type failed"
    virt-make-fs -v --format=qcow2 --type=ext4 --size=+200M ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs -v failed"
    virt-make-fs -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-make-fs -V failed"
    virt-make-fs -x ./test/ output.img
    CHECK_RESULT $? 0 0 "Check virt-make-fs -x failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
