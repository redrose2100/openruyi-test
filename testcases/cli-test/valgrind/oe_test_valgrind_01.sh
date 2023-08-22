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

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  return 0;
}
EOF
    g++ -g -o valgrind_test valgrind_test.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    ### -h --help ###
    valgrind -h | grep "usage: valgrind"
    CHECK_RESULT $? 0 0 "execute valgrind -h error"
    valgrind --help | grep "usage: valgrind"
    CHECK_RESULT $? 0 0 "execute valgrind -h error"

    ### --help-debug ###
    valgrind --help-debug | grep "debugging options"
    CHECK_RESULT $? 0 0 "execute valgrind --help-debug error"

    ### --help-dyn-options ###
    valgrind --help-dyn-options | grep "dynamically changeable options"
    CHECK_RESULT $? 0 0 "execute valgrind --help-dyn-options error"

    ### --version ###
    valgrind --version | grep -E "valgrind-[0-9]+.[0-9]+.[0-9]+"
    CHECK_RESULT $? 0 0 "execute valgrind --version error"

    ### --tool ###
    valgrind --tool=memcheck ./valgrind_test > valgrind_test.log 2>&1
    grep "HEAP SUMMARY" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --tool error"

    ### --leak-check ###
    valgrind --leak-check=full ./valgrind_test > valgrind_test.log 2>&1
    grep "Rerun with --leak-check=full to see details of leaked memory" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --leak-check error"

    ### --leak-resolution ###
    valgrind --leak-resolution=low ./valgrind_test > valgrind_test.log 2>&1
    grep "HEAP SUMMARY" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --leak-resolution error"

    ### --show-leak-kinds=none ###
    valgrind --leak-check=full --show-leak-kinds=none  ./valgrind_test > valgrind_test.log 2>&1
    grep "Reachable blocks (those to which a pointer was found) are not shown" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-leak-kinds error"

    ### --errors-for-leak-kinds ###
    valgrind --leak-check=full --errors-for-leak-kinds=none  ./valgrind_test > valgrind_test.log 2>&1
    grep "ERROR SUMMARY: 0 errors from 0 contexts" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --errors-for-leak-kinds error"

    ### --leak-check-heuristics ###
    valgrind --leak-check=full --leak-check-heuristics=stdstring  ./valgrind_test > valgrind_test.log 2>&1
    grep "ERROR SUMMARY: 3 errors from 3 contexts" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --leak-check-heuristics error" 
    
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
