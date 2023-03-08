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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.2.20
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-binutils--nm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "binutils gcc"
    mkdir /tmp/test/
    path=/tmp/test/
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
    cd /tmp/test/&&gcc -Wall -c main.c hello.c bye.c 
    ls -al ${path} | grep 'main.o\|hello.o\|bye.o'
    CHECK_RESULT $? 0 0 "Compile failure"
 
    nm main.o hello.o bye.o > nm.txt
    test -f nm.txt
    CHECK_RESULT $? 0 0 "file is failed"

    grep -E "T main|T hello|T bye" ${path}/nm.txt
    CHECK_RESULT $? 0 0 "content is error"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${path}
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

