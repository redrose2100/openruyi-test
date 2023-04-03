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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   test binutils-readelf
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "binutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > main.c << EOF
int main(int argc,char *argv[])
{
hello();
bye();
return 0;
}
EOF
    cat > hello.c << EOF
void hello(void)
{
printf("hello!\n");
}
EOF
    cat > bye.c << EOF
void bye(void)
{
printf("good bye!\n");
}
EOF
    gcc -Wall -c main.c hello.c bye.c
    for file in main.c hello.c bye.c main.o hello.o bye.o;do
        test -e $file
        CHECK_RESULT $? 0 0 "$file file not found"
    done
    for file in main.o hello.o bye.o;do
        readelf -h $file | grep 'ELF64'
        CHECK_RESULT $? 0 0 "$file file view failed"
    done
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf main.c hello.c bye.c main.o hello.o bye.o
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

