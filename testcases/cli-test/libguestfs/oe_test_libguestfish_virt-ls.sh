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
    


    virt-ls --format=qcow2 -a 22.img /etc
    virt-ls -lR -d vm22 --checksum=md5 --time-days /etc/ ｜ awk '$6 <= 7'
    virt-ls -c test:///default -a 22.img /etc
    virt-ls --csv -lR  -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'
    virt-ls -d vm4 /etc
    virt-ls -lR -d vm22 --echo-keys /etc/ ｜ awk '$6 <= 7'
    virt-ls -lR --extra-stats -d vm22  /etc/ ｜ awk '$6 <= 7'
    virt-ls --format=qcow2 -a 22.img /etc
    virt-ls --help | grep 'virt-ls: list'
    CHECK_RESULT $? 0 0 "Check virt-ls --help failed"
    virt-ls -h -lR  -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'
    

    virt-ls --key ID:key:KEY_STRING -lR -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'
    virt-ls --keys-from-stdin -lR -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'
    virt-ls -l -lR -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'

    virt-ls -R -d vm4 /etc/
    virt-ls -lR --times -d vm4 /etc/ ｜ awk '$6 <= 7'
    virt-ls -lR -d vm4 --time-days /etc/ ｜ awk '$6 <= 7'
    virt-ls -lR --time-relative -d vm4 /etc/
    virt-ls -lR --time-t -d vm4 /etc/
    virt-ls -lR --uids -d vm4 /etc/


    virt-ls -v -d vm4 /etc/
    virt-ls -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-ls -V failed"
    virt-ls -x -d vm4 /etc/



    
    
    
    
    
    
    


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
