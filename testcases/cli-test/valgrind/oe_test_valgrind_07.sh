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

 cat > valgrind_test_largestack.cpp << EOF
#include <iostream>
void recursiveFunction(int depth) {
    int data[1024]; // Allocate some data on the stack
    if (depth > 0) {
        recursiveFunction(depth - 1);
    }
}

int main() {
    // Call the recursive function to allocate stack space
    recursiveFunction(100);

    std::cout << "Stack allocated." << std::endl;

    return 0;
}
EOF

    g++ -g -o valgrind_test valgrind_test.cpp
    g++ -g -o valgrind_test_largestack valgrind_test_largestack.cpp
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start to run test."

    ### --max-stackframe ###
    valgrind  --max-stackframe=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "Invalid read of size 8" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --max-stackframe error"

    ### --main-stacksize ###
    valgrind --main-stacksize=1048576 ./valgrind_test_largestack > valgrind_test.log 2>&1
    grep "Stack allocated." valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --main-stacksize error"

    ### --max-threads ###
    valgrind --max-threads=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "Use --max-threads=INT to specify a larger number of threads" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --max-threads error"

    ### --alignment ###
    valgrind --alignment=32 ./valgrind_test_largestack
    CHECK_RESULT $? 0 0 "execute valgrind --alignment error"

    ### --redzone-size ###
    valgrind --redzone-size=0 ./valgrind_test_largestack
    CHECK_RESULT $? 0 0 "execute valgrind --redzone-size error"  

    ### --xtree-memory ###
    valgrind --xtree-memory=allocs ./valgrind_test_largestack
    grep "creator: xtree-1"  xtmemory.kcg.*
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory  error" 

    ### --xtree-memory-file ###
    valgrind --xtree-memory=allocs --xtree-memory-file=valgrind_test_xtmemory.log ./valgrind_test_largestack
    grep "creator: xtree-1"  valgrind_test_xtmemory.log
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory-file  error" 



    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf vgcore*
    rm -rf xtmemory.kcg.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
