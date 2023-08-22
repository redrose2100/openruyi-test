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
    ### cg_annotate  Command-line Options ###

    valgrind --tool=cachegrind ./valgrind_test
    CHECK_RESULT $? 0 0 "prepare cachegrind.out file fail"

    ### --threshold ###
    cg_annotate --threshold=0.2% cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute vcg_annotate --threshold  error"

    ### --show-percs ###
    cg_annotate --show-percs=no cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute vcg_annotate --show-percs error"

    ### --auto ###
    cg_annotate --auto=yes cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute vcg_annotate --auto error"

    ### --context ###
    cg_annotate --context=16 cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute vcg_annotate --context error" 

    ### cg_merge -o ###
    cg_merge -o cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute cg_merge -o error" 

    ### cg_diff Command-line Options ###
    
    ### -h --help ###
    cg_diff -h > valgrind_test.log 2>&1
    grep "usage: cg_diff" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff -h error"
    cg_diff --help valgrind_test.log 2>&1
    grep "usage: cg_diff" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff --help error"

    ## --version ### 
    cg_diff --version > valgrind_test.log 2>&1
    grep -E "cg_diff-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff --version error"
    
    ### --mod-filename ###
    cg_diff --mod-filename='s/prog[0-9]/projN/' cachegrind.out.* cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute cg_diff --mod-filename error"

    ### --mod-funcname ###
    cg_diff --mod-funcname='s/prog[0-9]/projN/' cachegrind.out.* cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute cg_diff --mod-funcname error"

    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf cachegrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
