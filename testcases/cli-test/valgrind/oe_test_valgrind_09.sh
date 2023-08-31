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

    ### --kernel-variant ###
    valgrind --kernel-variant=bproc,android-no-hw-tls,android-gpu-sgx5xx,android-gpu-adreno3xx ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --kernel-variant error"

    ### --merge-recursive-frames ###
    valgrind --merge-recursive-frames=0 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --merge-recursive-frames error"

    ### --num-transtab-sectors ###
    valgrind --num-transtab-sectors=10 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --num-transtab-sectors error"

    ### --avg-transtab-entry-size ###
    valgrind --avg-transtab-entry-size=64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --avg-transtab-entry-size error"

    ### --aspace-minaddr ###
    valgrind --aspace-minaddr=0x20000 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --aspace-minaddr error"

    ### --valgrind-stacksize ###
    valgrind --valgrind-stacksize=10240 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --valgrind-stacksize error"

    ### --show-emwarns ###
    valgrind --show-emwarns=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"
    valgrind --show-emwarns=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"

    ### --require-text-symbol ###
    valgrind --require-text-symbol=:*libc.so*:malloc ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --require-text-symbol error"

    ### --soname-synonyms ###
    valgrind --soname-synonyms=somalloc=NONE ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --soname-synonyms error"

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
