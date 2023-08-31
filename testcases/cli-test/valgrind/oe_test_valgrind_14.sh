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

    ### --instr-atstart ###
    valgrind --tool=callgrind --instr-atstart=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --instr-atstart error"

    ### --collect-atstart ###
    valgrind --tool=callgrind --collect-atstart=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-atstart error"

    ### --toggle-collect ###
    valgrind --tool=callgrind --toggle-collect=test01 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --toggle-collect error"

    ### --collect-jumps ###
    valgrind --tool=callgrind --collect-jumps=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-jumps error"

    ### --collect-systime ###
    valgrind --tool=callgrind --collect-systime=usec ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-systime error"

    ### --collect-bus ###
    valgrind --tool=callgrind --collect-bus=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-bus error"

    ### --separate-threads ###
    valgrind --tool=callgrind --separate-threads=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-threads error"

    ### --separate-callers ###
    valgrind --tool=callgrind --separate-callers=2 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers error"

    ### --separate-callers<number>=<function> ###
    valgrind --tool=callgrind --separate-callers2=test01 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers2 error"

    ### --separate-recs ###
    valgrind --tool=callgrind --separate-recs=3 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-recs error"


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
