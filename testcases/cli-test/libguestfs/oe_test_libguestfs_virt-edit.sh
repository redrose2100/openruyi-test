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
    
    virt-edit -a 22.img  /etc/a.txt
    virt-edit -b test.ext -d vm4  /etc/a.txt
    virt-edit -c test:///default -a 22.img  /etc/a.txt
    virt-edit -d vm4 /etc/a.txt
    virt-edit --echo-keys -d vm4  /etc/a.txt
    virt-edit -d vm4 /etc/a.txt  -e 'expr'
    virt-edit --format=qcow2  -a 22.img  /etc/a.txt
    virt-edit --help 2>&1 | grep 'virt-edit'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
    virt-edit --key ID:key:KEY_STRING -d vm4 /etc/a.txt
    virt-edit --keys-from-stdin -d vm4 /etc/a.txt


    virt-edit -v -d vm4 /etc/a.txt

    virt-edit -V  2>&1 ｜ grep  $(rpm -q libguestfs --queryformat '%{version}\n')
    virt-edit -x -d vm4 /etc/a.txt


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
