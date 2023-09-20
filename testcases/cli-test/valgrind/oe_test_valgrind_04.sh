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
# @Author    :   jiangchenyang
# @Contact   :   jiangcy1129@163.com
# @Date      :   2023-08-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo"

    cat > valgrind_test.cpp << EOF
#include <iostream>
#include <cstring>


void test01() {
  char* p = new char[8];
}

void test02() {
  static char* p = new char[8];
}

class Object {
public:
  Object() { _p = new char[8]; }
  ~Object() { if(_p) delete _p; }
private:
  char* _p = nullptr;
};

void test03() {
  Object* obj = new Object();
};

void test04() {
  char* data = new char[8];
  static char* p = data + 1;
}

void test05(){
    int* ptr = new int;
    delete[] ptr; 
}

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  test05(); // --show-mismatched-frees
  int x;
  int y=x+5;
  return 0;
}
EOF

cat > valgrind_test_fork.cpp << EOF
#include <iostream>
#include <unistd.h>
#include <stdio.h>
int main() {
    std::cout << "Main process: PID = " << getpid() << std::endl;

    pid_t childPid = fork(); // Create a child process

    fprintf(stdout, "This is standard output.\n");
    fprintf(stderr, "This is standard error.\n");
    if (childPid == 0) {
        // This is the child process
        std::cout << "Child process: PID = " << getpid() << std::endl;
        return 1;
    } else if (childPid > 0) {
        // This is the parent process
        std::cout << "Parent process: Created child with PID = " << childPid << std::endl;
    } else {
        std::cerr << "Failed to fork" << std::endl;
        return 1;
    }

    return 0;
}
EOF

    g++ -g -o valgrind_test valgrind_test.cpp
    g++ -g -o valgrind_test_fork valgrind_test_fork.cpp 
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start to run test."

    ### --ignore-ranges ###
    valgrind --ignore-ranges=0x0-0xFFFFFFFFFFFFFFFF ./valgrind_test > valgrind_test.log 2>&1
    grep "definitely lost: 40 bytes in 5 blocks" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --ignore-ranges error"
    
    ### --malloc-fill ###
    valgrind --leak-check=full --malloc-fill=0xAA ./valgrind_test > valgrind_test.log 2>&1
    CHECK_RESULT $? 0 0 "execute valgrind --malloc-fill error"

    ### --free-fill ###
    valgrind --leak-check=full --free-fill=0xAA ./valgrind_test > valgrind_test.log 2>&1
    CHECK_RESULT $? 0 0 "execute valgrind --free-fill error"

     ### --log-fd ###
    valgrind --log-fd=2 ./valgrind_test_fork > valgrind_test.log
    grep "This is standard output" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --log-fd error"

    ### --log-file ###
    valgrind --log-file=valgrind_test.log ./valgrind_test_fork
    grep "HEAP SUMMARY" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --log-file error"
    
    ### --log-socket ###
    valgrind --log-socket=127.0.0.1 ./valgrind_test_fork > valgrind_test.log 2>&1
    grep "logging server '127.0.0.1'" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --log-socket error"


    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf xtleak.kcg.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
