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
    
    
    virt-diff -a 1.img -A 2.img
    virt-diff --all -d vm1 -D vm2
    virt-diff --atime -d vm1 -D vm2
    virt-diff -a 1.img -A 2.img
    virt-diff --checksum=crc -d vm1 -D vm2
    virt-diff -c test:///default -a 1.img -A 2.img
    virt-diff --csv -a 1.img -A 2.img
    virt-diff --dir-links -a 1.img -A 2.img
    virt-diff --dir-times -a 1.img -A 2.img
    virt-diff -d vm1 -D vm2



    virt-diff --all -d vm1 -D vm2
    virt-diff --echo-keys -a 1.img -A 2.img
    virt-diff --extra-stats -d vm1 -D vm2
    virt-diff --format=qcow2 -a 1.img -A 2.img
    virt-diff -a 1.img -A 2.img
    virt-diff --help 2>&1 | grep 'virt-diff'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
    virt-diff -h -a 1.img -A 2.img
    virt-diff --key ID:key:KEY_STRING -a 1.img -A 2.img
    virt-diff --keys-from-stdin -a 1.img -A 2.img
    virt-diff --times -a 1.img -A 2.img
    virt-diff --time-days -a 1.img -A 2.img


    virt-diff --time-relative -a 1.img -A 2.img
    virt-diff --time-t -a 1.img -A 2.img
    virt-diff --uids -a 1.img -A 2.img
    virt-diff -v -a 1.img -A 2.img
    virt-diff -V 2>&1 ｜ grep  $(rpm -q libguestfs --queryformat '%{version}\n')
    virt-diff -x -a 1.img -A 2.img
    virt-diff --xattrs -a 1.img -A 2.img



    

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
