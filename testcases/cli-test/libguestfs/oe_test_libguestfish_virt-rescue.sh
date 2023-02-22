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
    
    virt-rescue -a CentOS-7-aarch64-Minimal-2009.iso
    virt-rescue -d vm4 -i
    virt-rescue --append --blocksize=512 -d vm4
    virt-rescue -e ^x -d vm4
    virt-rescue --format=raw -a CentOS-7-aarch64-Minimal-2009.iso
    virt-rescue --help
    virt-rescue -d vm4 -i
    virt-rescue -m /dev/sda1:/:acl,user_xattr -d vm4
    virt-rescue --memsize 256  -d vm4

    virt-rescue --ro -d vm4
    virt-rescue --scratch=3 -d vm4
    virt-rescue --selinux -d vm4
    virt-rescue --smp 2 -d vm4
    virt-rescue -v -d vm4
    virt-rescue -V 2>&1 ｜ grep $(rpm -q libguestfs --queryformat '%{version}\n')

    virt-rescue --rw -d vm4
    virt-rescue -x -d vm4





    
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
