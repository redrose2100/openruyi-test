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
# @Desc      :   verify the uasge of libguestfs virt-alignment-scan command
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
    virt-alignment-scan -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -a failed"
    virt-alignment-scan -c test:///default -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -c failed"
    virt-alignment-scan -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -d failed"
    virt-alignment-scan --format=raw -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan --format failed"
    virt-alignment-scan --help 2>&1 | grep 'virt-alignment-sca'
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan --help failed"
    virt-alignment-scan -P 2 -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -P failed"
    virt-alignment-scan -q -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -q failed"
    virt-alignment-scan --uuid
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan --uuid failed"
    virt-alignment-scan -v -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -v failed"
    virt-alignment-scan --version 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan --version failed"
    virt-alignment-scan -x -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-alignment-scan -x failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
