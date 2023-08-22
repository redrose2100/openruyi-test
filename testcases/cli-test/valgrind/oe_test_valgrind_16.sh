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
    ### Callgrind Command-line Options ###

    ### --D1=<size>,<associativity>,<line size> ###
    valgrind --tool=callgrind --D1=1024,8,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --D1 error"

    ### --LL=<size>,<associativity>,<line size> ###
    valgrind --tool=callgrind --LL=4096,16,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --LL error"


    ### callgrind_annotate Command-line Options ###

    ### -h --help ###
    callgrind_annotate -h > valgrind_test.log 2>&1
    grep "usage: callgrind_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate -h error"
    callgrind_annotate --help valgrind_test.log 2>&1
    grep "usage: callgrind_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --help error"

    ## --version ### 
    callgrind_annotate --version > valgrind_test.log 2>&1
    grep -E "callgrind_annotate-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --version error"

    ### --show ###
    callgrind_annotate --show=Ir callgrind.out.* > valgrind_test.log 2>&1
    grep "events annotated" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute allgrind_annotate --show error"

    ### --sort ###
    callgrind_annotate --sort=Ir callgrind.out.* > valgrind_test.log 2>&1
    grep "events annotated" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --sort error"

    ### --threshold ###
    callgrind_annotate --threshold=0.2% callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --threshold  error"

    ### --show-percs ###
    callgrind_annotate --show-percs=no callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --show-percs error"

    ### --auto ###
    callgrind_annotate --auto=yes callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --auto error"

    ### --context ###
    callgrind_annotate --context=16 callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --context error" 

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
