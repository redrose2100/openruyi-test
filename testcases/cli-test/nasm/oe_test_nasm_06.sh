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
    touch myfile.asm
    touch file.asm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nasm -O1 myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -O1 failed"
    nasm -Ox myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -Ox failed"
    nasm -Ov myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -Ov failed"
    nasm -t myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -t failed"
    nasm -E myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -E failed"
    nasm -e myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -e failed"
    nasm -a -f dbg myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -a failed"
    nasm -Ipath myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -Ipath failed"
    nasm -Pfile file.asm
    CHECK_RESULT $? 0 0 "Check nasm -Pfile failed"
    nasm -Damcro'str' myfile.asm
    CHECK_RESULT $? 0 0 "Check nasm -Damcro failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf myfile* file nasm* t* imit-* out*
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
