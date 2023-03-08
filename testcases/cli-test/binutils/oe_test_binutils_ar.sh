#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.2.10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-binutils--ar
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "binutils"
    touch file1.c file2.c file3.c
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    gcc -Wall -c file1.c file2.c file3.c
    CHECK_RESULT $? 0 0 "Compilation failure"
    ls | grep -E "file[1-3]{1}.o" >test-binutils.txt
    out=$(cat test-binutils.txt)
    file="file1.o file2.o file3.o"
    CHECK_RESULT $out $file 0 "File generation failure"
    ar rv libNAME.a file1.o file2.o file3.o
    CHECK_RESULT $? 0 0 "Generation failure"
    test -f libNAME.a
    CHECK_RESULT $? 0 0 "File does not exist"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf file* libNAME.a
    LOG_INFO "Finish environment cleanup!"
}

main $@


