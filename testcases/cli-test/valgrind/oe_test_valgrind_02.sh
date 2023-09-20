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

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  test05(); // --show-mismatched-frees
  int x;
  int y=x+5;
  return 0;
}
EOF
    g++ -g -o valgrind_test valgrind_test.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    ### --show-reachable ###  
    valgrind --leak-check=full --show-reachable=no ./valgrind_test > valgrind_test.log 2>&1
    grep "eachable blocks (those to which a pointer was found) are not shown" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-reachable error" 

    ### --show-possibly-lost ###  
    valgrind --leak-check=full --show-possibly-lost=no  ./valgrind_test > valgrind_test.log 2>&1
    grep "8 bytes in 1 blocks are possibly lost in loss record" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --show-possibly-lost error" 

    ### --xtree-leak ###
    valgrind --xtree-leak=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "xtree leak report" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak error" 
    
    ### --xtree-leak-file ###
    valgrind --xtree-leak=yes --xtree-leak-file=valgrind_test_report.txt ./valgrind_test 
    grep "# callgrind format" valgrind_test_report.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak-file error" 

    ### --expensive-definedness-checks ###
    valgrind --expensive-definedness-checks=no ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --expensive-definedness-checks error" 

    ### --keep-stacktraces ###
    valgrind --leak-check=full --keep-stacktraces=none ./valgrind_test > valgrind_test.log 2>&1
    grep "at 0x0: ???" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --keep-stacktraces error" 

    ### --freelist-vol ###
    valgrind --leak-check=full --freelist-vol=100 ./valgrind_test > valgrind_test.log 2>&1
    grep "freelist-vol value 100" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error" 

    ### --freelist-big-blocks ###
    valgrind --leak-check=full --freelist-big-blocks=30000000 ./valgrind_test > valgrind_test.log 2>&1
    grep "reelist-big-blocks value 30000000" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error" 

    ### --workaround-gcc296-bugs ###
    valgrind --leak-check=full --workaround-gcc296-bugs=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Warning: --workaround-gcc296-bugs=yes is deprecated." valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --workaround-gcc296-bugs error" 
    
    ### --show-mismatched-frees ###
    valgrind  --show-mismatched-frees=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Mismatched free() \/ delete \/ delete \[\]" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --show-mismatched-frees error"
    
    ### --10-- ###

    # ### --ignore-ranges ###
    # valgrind --ignore-ranges=0x0-0xFFFFFFFFFFFFFFFF ./valgrind_test > valgrind_test.log 2>&1
    # grep "definitely lost: 40 bytes in 5 blocks" valgrind_test.log
    # CHECK_RESULT $? 0 0 "execute valgrind --ignore-ranges error"
    
    # ### --malloc-fill ###
    # valgrind --leak-check=full --malloc-fill=0xAA ./valgrind_test > valgrind_test.log 2>&1
    # CHECK_RESULT $? 0 0 "execute valgrind --malloc-fill error"

    # ### --free-fill ###
    # valgrind --leak-check=full --free-fill=0xAA ./valgrind_test > valgrind_test.log 2>&1
    # CHECK_RESULT $? 0 0 "execute valgrind --free-fill error"

    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    rm -rf xtleak.kcg.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
