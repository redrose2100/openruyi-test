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
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of nasm command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nasm
    touch file.asm
    touch myfile.out
    touch myfile.asm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nasm -h 2>&1 | grep 'Usage: nasm'
    CHECK_RESULT $? 0 0 "Check nasm -h failed"
    nasm -v 2>&1 | grep 'NASM version'
    CHECK_RESULT $? 0 0 "Check nasm -v failed"
    nasm -@ myfile.asm myfile.out
    CHECK_RESULT $? 0 0 "Check nasm -@ failed"
    nasm -o outfile myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -o failed"
    nasm --keep-all myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm --keep-all failed"
    nasm file.asm -X gnu
    CHECK_RESULT $? 0 0 "Check nasm -X gun failed"
    nasm file.asm -X vc
    CHECK_RESULT $? 0 0 "Check nasm -X vc failed"
    nasm -s file.asm
    CHECK_RESULT $? 0 0 "Check nasm -s failed"
    nasm -Zfile file.asm
    CHECK_RESULT $? 0 0 "Check nasm -Zfile failed"
    nasm -M file.asm
    CHECK_RESULT $? 0 0 "Check nasm -M failed"
    LOG_INFO "End to run  test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file* out*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
