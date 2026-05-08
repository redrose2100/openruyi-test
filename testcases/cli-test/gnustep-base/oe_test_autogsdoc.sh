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
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/08/26
# @License   :   Mulan PSL v2
# @Desc      :   Test autogsdoc generate .c file document
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gnustep-base"
    cat > hello.c << eof
#include <stdio.h>
int main(void){
printf("hello world\n");
return 0;
}
eof
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    autogsdoc hello.c
    CHECK_RESULT $? 0 0 "autogsdoc run failed."
    test -f hello.html
    CHECK_RESULT $? 0 0 "autogsdoc cannot gnerate hello.html"
    test -f hello.gsdoc
    CHECK_RESULT $? 0 0 "autogsdoc cannot generate hello.gsdoc"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf hello.c hello.gsdoc hello.html OrderedSymbolDeclarations.plist Untitled.igsdoc
    LOG_INFO "End to restore the test environment."
}

main "$@"
