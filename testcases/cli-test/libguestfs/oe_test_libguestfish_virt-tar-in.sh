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
    
    

    
    
    
    virt-tar-in -d vm4 qemu-4.2.0.tar /etc/
    virt-tar-in -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-copy-in -V failed"
    virt-tar-in -a 22.img virt-tar-in -a 22.img /opt/software/qemu-4.2.0.tar /etc/ /etc/
    
    

    virt-tar-in -h 2>&1 | grep 'display a list of commands'
    CHECK_RESULT $? 0 0 "Check virt-copy-in -h failed"


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
