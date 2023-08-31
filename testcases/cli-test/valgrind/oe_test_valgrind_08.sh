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
# @Date      :   2023-08-20
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

    ### --smc-check ###
    valgrind  --smc-check=all ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --smc-check error"

    ### --read-inline-info ###
    valgrind --read-inline-info=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --read-inline-info error"

    ### --read-var-info ###
    valgrind --read-var-info=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --read-var-info error"
    
    ### --vgdb-poll ###
    valgrind --vgdb-poll=1000 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-poll error"

    ### --vgdb-shadow-registers ###
    valgrind --vgdb-shadow-registers=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-shadow-registers error"
    
    ### --vgdb-prefix ###
    valgrind --vgdb-prefix=/tmp/prefix ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-prefix error"

    ### --run-libc-freeres ###
    valgrind --run-libc-freeres=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --run-libc-freeres error"

    ### --run-cxx-freeres ###
    valgrind --run-cxx-freeres=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --run-cxx-freeres error"

    ### --sim-hints ###
    valgrind --sim-hints=lax-ioctls,fuse-compatible ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --sim-hints error"

    ### --fair-sched ###
    valgrind --fair-sched=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --fair-sched error"

    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf vgcore*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
