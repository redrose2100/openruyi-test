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
# @Desc      :   verify the uasge of libguestfs virt-tar command
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
    virt-tail -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail -d failed"
    virt-tail -c test:///default -a 22.img /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail -c failed"
    virt-tail -f -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail -f failed"
    virt-tail --echo-keys -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail --echo-keys failed"
    virt-tail --format=qcow2 -a 22.img /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail --format failed"
    virt-tail --help 2>&1 | grep 'virt-tail'
    CHECK_RESULT $? 0 0 "Check virt-tail --help failed"
    virt-tail --key ID:key:KEY_STRING -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail --key failed"
    virt-tail --keys-from-stdin -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail --keys-from-stdin failed"
    virt-tail -v -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail -v failed"
    virt-tail -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-tail -V failed"
    virt-tail -x -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-tail -x failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
