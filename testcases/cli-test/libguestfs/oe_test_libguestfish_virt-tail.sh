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

    virt-tail -d vm4 /etc/a.txt
    virt-tail -c test:///default -a 22.img /etc/a.txt
    virt-tail -f -d vm4 /etc/a.txt

    virt-tail --echo-keys -d vm4 /etc/a.txt
    virt-tail -f -d vm4 /etc/a.txt
    virt-tail --format=qcow2 -a 22.img /etc/a.txt
    virt-tail --help 2>&1 | grep 'virt-tail'
    CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
    virt-tail --key ID:key:KEY_STRING -d vm4 /etc/a.txt
    virt-tail --keys-from-stdin -d vm4 /etc/a.txt
    virt-tail -v -d vm4 /etc/a.txt
    virt-tail -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check guestunmount -V failed"
    virt-tail -x -d vm4 /etc/a.txt


    
    

    
    


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
