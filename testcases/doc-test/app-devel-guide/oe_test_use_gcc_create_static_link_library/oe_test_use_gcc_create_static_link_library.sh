#!/usr/bin/bash
#!/usr/bin/expect

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   test_compile_gcc_create_use_libraries
# @Author    :   dingjiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Using gcc to create and use dynamic link libraries
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "gcc"
    mkdir -p /home/code/src /home/code/lib /home/code/include
    cp ../common/add.c ../common/sub.c /home/code/src/
    cp ../common/math.h /home/code/include
    cp ../common/main.c /home/code/src
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    gcc -c /home/code/src/add.c /home/code/src/sub.c
    CHECK_RESULT $? 0 0 "Compiling add.c, sub.c failed!"
    test -e add.o -a -e sub.o
    CHECK_RESULT $? 0 0 "The add.o and sub.o does not exist!"
    ar rcs /home/code/lib/libmath.a add.o sub.o
    CHECK_RESULT $? 0 0 "Failed to generate static library /home/code/lib/libmath.a!"
    test -e /home/code/lib/libmath.a
    CHECK_RESULT $? 0 0 "The libmath.a does not exist!"
    gcc /home/code/src/main.c -I /home/code/include -L /home/code/lib -lmath -o math.out
    CHECK_RESULT $? 0 0 "Compiling math.out failed!"
    test -e math.out
    CHECK_RESULT $? 0 0 "The math.out does not exist in the lib directory!"
    expect -c"
        spawn  ./math.out
        expect{
             \"Please input a and b:\" {
                send \"9 2\"
                exp_continue
        }
        \"The add: 11\n The sub: 7\"

    }"
    CHECK_RESULT $? 0 0 "Failed to execute math.out!"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf /home/code math.out add.o sub.o
    DNF_REMOVE "$@"
    LOG_INFO "End environment cleanup."
}

main "$@"
