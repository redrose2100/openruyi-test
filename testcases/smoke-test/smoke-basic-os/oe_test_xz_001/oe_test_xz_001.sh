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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2022-11-08
# @License   :   Mulan PSL v2
# @Desc      :   Command test-xz
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."    
    touch 11.txt&&echo "test" >> 11.txt                                 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa xz
    CHECK_RESULT $? 0  

    xz -V
    CHECK_RESULT $? 0

    xz -h 
    CHECK_RESULT $? 0
    
    xz -z 11.txt
    list = $(ls -al)
    CHECK_RESULT $((list)) 0 0  "11.txt.xz"

    xz -d 11.txt
    list = $(ls -al)
    CHECK_RESULT $((list)) 0 0  "11.txt"

    xz 11.txt
    list = $(ls -al)
    CHECK_RESULT $((list)) 0 0  "11.txt.xz"

    xzcat 11.txt.xz
    CHECK_RESULT $? 0
   
    unxz 11.txt.xz
    list = $(ls -al)
    CHECK_RESULT $((list)) 0 0  "11.txt"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    rm -rf 11.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
