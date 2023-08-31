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

    ### Cachegrind Command-line Options ###

    ### --cachegrind-out-file ###
    valgrind --tool=cachegrind --cachegrind-out-file=valgrind_test.log ./valgrind_test
    grep "cache" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cachegrind-out-file error"

    ### --cache-sim ###
    valgrind --tool=cachegrind --cache-sim=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cache-sim error"

    ### --branch-sim ###
    valgrind --tool=cachegrind --branch-sim=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Branches:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --branch-sim error"

    ### --I1 ###
    valgrind --tool=cachegrind --cache-sim=yes --I1=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"

    ### --D1 ###
    valgrind --tool=cachegrind --cache-sim=yes --I1=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --D1 error"

    ### --LL ###
    valgrind --tool=cachegrind --cache-sim=yes --LL=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"


    ### cg_annotate  Command-line Options ###

    ### -h --help ###
    cg_annotate -h > valgrind_test.log 2>&1
    grep "usage: cg_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_annotate -h error"
    cg_annotate --help valgrind_test.log 2>&1
    grep "usage: cg_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_annotate --help error"

    ## --version ### 
    cg_annotate --version > valgrind_test.log 2>&1
    grep -E "cg_annotate-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_annotate --version error"

    ### --show ###
    cg_annotate --show=Ir cachegrind.out.* > valgrind_test.log 2>&1
    grep "events annotated" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_annotate --show error"

    ### --sort ###
    cg_annotate --sort=Ir cachegrind.out.* > valgrind_test.log 2>&1
    grep "events annotated" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_annotate --sort error"


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
