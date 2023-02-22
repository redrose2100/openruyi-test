#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libguestfs
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-get-kernel -a 1.img
    virt-get-kernel -c test:///default -a 1.img
virt-get-kernel -d vm1

virt-get-kernel --echo-keys -d vm1
virt-get-kernel --format=qcow2 -a 1.img
virt-get-kernel --help 2>&1 | grep 'virt-get-kernel'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"

virt-get-kernel --key ID:key:KEY_STRING -d vm1
virt-get-kernel --keys-from-stdin -d vm1
    virt-get-kernel --machine-readable 2>&1 | grep 'virt'
    CHECK_RESULT $? 0 0 "Check guestunmount --machine-readable failed"



virt-get-kernel -o /etc/ -d vm4
virt-get-kernel --prefix pre -d vm4
virt-get-kernel -q -d vm4
virt-get-kernel --unversioned-names -d vm4
virt-get-kernel -V 2>&1 ｜ grep $(rpm -q libguestfs --queryformat '%{version}\n')
virt-get-kernel -v -d vm4
virt-get-kernel -x -d vm4




    
    
    
    
    
    
    
    
    
    
    
    

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
