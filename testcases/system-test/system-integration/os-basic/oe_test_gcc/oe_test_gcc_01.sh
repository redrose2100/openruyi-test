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
# @Date      :   2023.4.19
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-gcc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc"
    mkdir /tmp/gcc_test
    lang=$(echo $LANG)
    LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    cat > main.c << EOF
#include<stdio.h>
int main(void)
{
  // Print the string
   int i;
   printf("\n The Geek Stuff [%d]\n", i);
   return 0;
}
EOF
    gcc -Wall main.c -o main >/tmp/gcc_test/log1 2>&1
    grep "warning: ‘i’ is used uninitialized in this function" /tmp/gcc_test/log1
    CHECK_RESULT $? 0 0 "Warning display failure"
    gcc -Wall -Werror main.c -o main >/tmp/gcc_test/log2 2>&1
    grep "error: ‘i’ is used uninitialized in this function" /tmp/gcc_test/log2
    CHECK_RESULT $? 0 0 "Error display failure"
    ./main
    gcc -save-temps main.c >/tmp/gcc_test/log3 2>&1
    grep "warning: ‘i’ is used uninitialized in this function" /tmp/gcc_test/log3
    gcc -save-temps main.c
    file=("a.out" "main.i" "main.o" "main.s")
    for i in ${file[@]}
    do
        test -f $i
        CHECK_RESULT $? 0 0 "File does not exist"
    done
    gcc -Wall -v main.c -o main >/tmp/gcc_test/log4 2>&1
    grep "gcc version" /tmp/gcc_test/log4
    CHECK_RESULT $? 0 0 "gcc version not found"
}

function post_test() {
    DNF_REMOVE
    LANG=$lang
    rm -rf /tmp/gcc_test
    rm -rf a.out main*
}

main $@

