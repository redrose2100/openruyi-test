#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   guobin
# @Contact   :   guobin@uniontech.com
# @Date      :   2024-03-28
# @License   :   Mulan PSL v2
# @Desc      :   openssl Encryption and decryption used sm4.CTR
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function config_params() {
    myfilelist="/tmp/test.txt"
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sm4_ctr
    touch $myfilelist
    echo 1234 > $myfilelist
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "start to run test."
    openssl enc -sm4-ctr -in $myfilelist -out encrypted_uos.bin -e -pass pass:123456 -pbkdf2 -iter 10000         
    CHECK_RESULT $? 0 0 "encrypted failed" 
    sudo openssl enc -sm4-ctr -engine gmi -in encrypted_uos.bin -out decrypt.txt -d -pass pass:123456 -pbkdf2 -iter 1000
    CHECK_RESULT $? 0 0 "decrtyption failed" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    DNF_REMOVE 
    rm -rf $myfilelist
    
    LOG_INFO "End to restore the test environment."
}

main $@
