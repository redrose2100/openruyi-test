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
# @Desc      :   verify the uasge of libguestfs virt-edit command
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
    virt-edit -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit -a failed"
    virt-edit -b test.ext -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit -b failed"
    virt-edit -c test:///default -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit -c failed"
    virt-edit -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit -d failed"
    virt-edit --echo-keys -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit --echo-keys failed"
    virt-edit -d openEuler-2003 /etc/a.txt -e 'expr'
    CHECK_RESULT $? 0 0 "Check virt-edit -e failed"
    virt-edit --format=qcow2 -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit --format failed"
    virt-edit --help 2>&1 | grep 'virt-edit'
    CHECK_RESULT $? 0 0 "Check virt-edit --help failed"
    virt-edit --key ID:key:KEY_STRING -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit --key failed"
    virt-edit --keys-from-stdin -d openEuler-2003 /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-edit --keys-from-stdin failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
