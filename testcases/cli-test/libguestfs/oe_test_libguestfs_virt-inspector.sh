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
    
    
    
    
    virt-inspector -a 1.img ｜ grep 'operatingsystems'
    virt-inspector -c test:///default -a 1.img ｜ grep 'operatingsystems'
    virt-inspector -d vm1
    virt-inspector --echo-keys -a 1.img
    virt-inspector --format=raw -a 1.img
    virt-inspector --help | grep 'virt-inspector: display'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
    virt-inspector --key "DEVICE":key:KEY_STRING -a 1.img
    virt-inspector --keys-from-stdin -a 1.img
    virt-inspector --no-applications -a 1.img
    virt-inspector --no-icon -a 1.img

    
    virt-inspector -v -a 1.img
    virt-inspector -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check guestunmount -V failed"
    virt-inspector -x -a 1.img
    virt-inspector -d vm22 ｜ virt-inspector --xpath '//filesystems'
    
    
    
    
    
    
    
    

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "End to restore the test environment."
}

main $@
