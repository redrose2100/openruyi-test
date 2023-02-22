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
    
    
    
    virt-df -a 1.img
    virt-df -c test:///default  -a 1.img
    virt-df --csv -a 1.img
    virt-df -d vm1
    virt-df --format=raw -a 1.img
    virt-df -h 1.img
    virt-df --help
    virt-df -i 1.img
    virt-df --one-per-guest 1.img
    virt-df -P 2 1.img
    virt-df --help 2>&1 | grep 'virt-df'
    CHECK_RESULT $? 0 0 "Check guestunmount virt-df --help failed"
    
    virt-df -v 1.img

    virt-df -V 2>&1 ｜ grep  $(rpm -q libguestfs --queryformat '%{version}\n') 
    virt-df -x 1.img

    
    
    
    
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
