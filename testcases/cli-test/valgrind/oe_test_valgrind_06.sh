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

void test06(){
  for (int i = 0; i < 1000000; ++i) {
    int uninitialized_variable;
    printf("%d\n", uninitialized_variable);
  }
}

void test07(){
    // This is an intentionally invalid instruction
    asm volatile ("ud2");
}

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  test05(); // --show-mismatched-frees
  //test06(); // --error-limit 
  test07(); // --sigill-diagnostics
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

cat > valgrind_test_suppressions.supp << EOF
{
   Mismatched free() / delete / delete []
   Memcheck:Leak
   fun:*
}
EOF

    g++ -g -o valgrind_test valgrind_test.cpp
    g++ -g -o valgrind_test_fork valgrind_test_fork.cpp
    objcopy --only-keep-debug valgrind_test_fork valgrind_test_fork.debug
    echo "y" > valgrind_test_input.txt
    exec 3< valgrind_test_input.txt
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start to run test."

    ### --error-markers ###
    valgrind --error-markers="begin_error,end_error" ./valgrind_test > valgrind_test.log 2>&1
    grep -Pzo "(?s)begin_error.*?end_error" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --error-markers error"

    ### -s --show-error-list ###
    valgrind --show-error-list=yes ./valgrind_test > valgrind_test.log 2>&1
    grep -E "[0-9]+ errors in context [0-9]+ of [0-9]+:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-error-list error"

    valgrind --show-error-list=yes ./valgrind_test > valgrind_test.log 2>&1
    grep -E "[0-9]+ errors in context [0-9]+ of [0-9]+:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-error-list error"
    
    ### --sigill-diagnostics ###
    valgrind --sigill-diagnostics=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "valgrind: Unrecognised instruction at address" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --sigill-diagnostics error"

    ### --show-below-main ###
    valgrind --show-below-main=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "__libc_start_main" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-below-main error"

    ### --fullpath-after ###
    valgrind --fullpath-after= ./valgrind_test > valgrind_test.log 2>&1
    grep "/usr/src/" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --fullpath-after error"

    ### --extra-debuginfo-path ###
    valgrind --extra-debuginfo-path=valgrind_test_fork.debug ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --extra-debuginfo-path error"

    ### --allow-mismatched-debuginfo ###
    valgrind --allow-mismatched-debuginfo=yes ./valgrind_test_fork
    CHECK_RESULT $? 0 0 "execute valgrind --allow-mismatched-debuginfo error"

    ### --suppressions ###
    valgrind --suppressions=valgrind_test_suppressions.supp -s ./valgrind_test > valgrind_test.log 2>&1
    grep "used_suppression:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --suppressions error"

    ### --gen-suppressions ###
    valgrind --gen-suppressions=all ./valgrind_test > valgrind_test.log 2>&1
    grep "<insert_a_suppression_name_here>" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --gen-suppressions error"

    ### --input-fd ###
    valgrind --gen-suppressions=yes --input-fd=3 ./valgrind_test valgrind_test.log 2>&1
    grep "<insert_a_suppression_name_here>" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --input-fd error"

    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    exec 3<&-
    rm -rf valgrind_test*
    rm -rf vgcore*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
