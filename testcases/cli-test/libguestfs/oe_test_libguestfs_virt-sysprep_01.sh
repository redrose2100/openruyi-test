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
# @Desc      :   verify the uasge of libguestfs virt-sysprep command
# ############################################

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    echo "hello" >a.txt
    virt-copy-in -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 a.txt /etc
    unset LIBGUESTFS_BACKEND
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-sysprep -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-sysprep -a failed"
    virt-sysprep --append-line '/etc/hosts:10.0.0.1 foo' -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
    virt-sysprep -c test:///default -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2
    CHECK_RESULT $? 0 0 "Check virt-sysprep --append-line failed"
    virt-sysprep --chmod 755:/etc/a.txt -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-sysprep --chmod failed"
    virt-sysprep --color -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-sysprep --color failed"
    virt-sysprep --commands-from-file /etc/a.txt -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-sysprep --commands-from-file failed"
    virt-sysprep -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 --copy /etc/a.txt:/opt
    CHECK_RESULT $? 0 0 "Check virt-sysprep --copy failed"
    virt-sysprep -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 --copy-in a.txt:/etc
    CHECK_RESULT $? 0 0 "Check virt-sysprep --copy-in failed"
    virt-sysprep -d openEuler-24.03-LTS-SP1
    CHECK_RESULT $? 0 0 "Check virt-sysprep -d failed"
    virt-sysprep -a /home/kvm/images/openEuler-24.03-LTS-SP1.qcow2 --delete /etc/a.txt
    CHECK_RESULT $? 0 0 "Check virt-sysprep --delete failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    LOG_INFO "Finish to restore the test environment."
}

main $@
