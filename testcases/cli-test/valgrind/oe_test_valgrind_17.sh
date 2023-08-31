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

    ### callgrind_annotate Command-line Options ###

    ### --inclusive ###
    callgrind_annotate --inclusive=yes callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --inclusive error" 

    ### --tree ###
    callgrind_annotate --tree=both callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --tree error" 

    ### -I --include ###
    callgrind_annotate -I=dir callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate -I error" 
    callgrind_annotate --include=dir callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --include error" 


    ### callgrind_control Command-line Options ###

    ### -h --help ###
    callgrind_control -h > valgrind_test.log 2>&1
    grep "Usage: callgrind_control" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control -h error"
    callgrind_control --help valgrind_test.log 2>&1
    grep "Usage: callgrind_control" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control --help error"

    ### --version ### 
    callgrind_control --version > valgrind_test.log 2>&1
    grep -E "callgrind_control-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control --version error"

    ### -l --long ### 
    callgrind_control -l callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -l error"
    callgrind_control --long callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --long error"

    ### -s --stat ###
    callgrind_control -s callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -s error"
    callgrind_control --stat callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --stat error"

    ### -b --back ###
    callgrind_control -b callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -b error"
    callgrind_control --back callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --back error"

    ### -e ###
    callgrind_control -e callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -e error"

    ### --dump ###
    callgrind_control --dump callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --dump error"

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
