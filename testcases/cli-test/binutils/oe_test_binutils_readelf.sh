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
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/05/18
# @License   :   Mulan PSL v2
# @Desc      :   test binutils-readelf
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "binutils gcc gcc-c++"
    mkdir /tmp/test
    path=/tmp/test
    cat > ${path}/main.c <<EOF
int main(int argc,char *argv[])
{
hello();
bye();
return 0;
}
EOF
    cat > ${path}/hello.c <<EOF
void hello(void)
{
printf("hello!\n");
}
EOF
    cat > ${path}/bye.c <<EOF
void bye(void)
{
printf("good bye!\n");
}
EOF
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/test/ && gcc -Wall -c main.c hello.c bye.c
    test -f main.o -a -f hello.o -a -f hello.o
    CHECK_RESULT $? 0 0 "Compilation failure"
    readelf -h hello.o | grep "Size of this header"
    CHECK_RESULT $? 0 0 "Failed to view file information using readelf. Procedure"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $path
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
