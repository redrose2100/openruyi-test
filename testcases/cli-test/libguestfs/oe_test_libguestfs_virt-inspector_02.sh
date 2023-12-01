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
# @Desc      :   verify the uasge of libguestfs virt-inspector command
# ############################################

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-inspector -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 | grep 'operatingsystems'
    CHECK_RESULT $? 0 0 "Check virt-inspector -a failed"
    virt-inspector -c test:///default -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2 | grep 'operatingsystems'
    CHECK_RESULT $? 0 0 "Check virt-inspector -c failed"
    virt-inspector -d openEuler-2003
    CHECK_RESULT $? 0 0 "Check virt-inspector -d failed"
    virt-inspector --echo-keys -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --echo-keys failed"
    virt-inspector --format=raw -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --format failed"
    virt-inspector --help | grep 'virt-inspector: display'
    CHECK_RESULT $? 0 0 "Check virt-inspector --help failed"
    virt-inspector --key "DEVICE":key:KEY_STRING -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --key failed"
    virt-inspector --keys-from-stdin -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --keys-from-stdin failed"
    virt-inspector --no-applications -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --help failed"
    virt-inspector --no-icon -a /home/kvm/images/openEuler-20.03-LTS-SP3.qcow2
    CHECK_RESULT $? 0 0 "Check virt-inspector --no-applications failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "End to restore the test environment."
}

main $@
