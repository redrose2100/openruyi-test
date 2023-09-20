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
# @Date      :   2023-08-29
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

    valgrind --tool=callgrind ./valgrind_test
    CHECK_RESULT $? 0 0 "prepare callgrind.out.* file fail"

    ### callgrind_control Command-line Options ###

    ### -z --zero ###
    callgrind_control -z callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -z error"
    callgrind_control --zero callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --zero error"

    ### -k --kill ###
    callgrind_control -k callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -k error"
    callgrind_control --kill callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --kill error"

    ### --instr=<on|off> ###
    callgrind_control --instr=on callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --instr=on error"
  
    ### --vgdb-prefix=<prefix> ###
    callgrind_control --vgdb-prefix=/tmo/prefix callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --vgdb-prefix error"

    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf callgrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
