#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023.08.15
# @License   :   Mulan PSL v2
# @Desc      :   package lzo-lzop test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lzo lzop"
    touch example.txt
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lzop example.txt -o example.txt.lzo
    test -f example.txt.lzo
    CHECK_RESULT $? 0 0 "the example.txt.lzo file does not exist "
    lzop -d example.txt.lzo -o example_uncompressed.txt
    test -f example_uncompressed.txt
    CHECK_RESULT $? 0 0 "the example_uncompressed.txt file does not exist"
    lzop -l example.txt.lzo | grep -i method
    CHECK_RESULT $? 0 0 "no method found"
    lzop --help  
    CHECK_RESULT $? 0 0 "execution failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf example.txt 
    rm -rf example.txt.lzo
    rm -rf example_uncompressed.txt
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

