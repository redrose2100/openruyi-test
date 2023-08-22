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

void test06(){
  for (int i = 0; i < 1000000; ++i) {
    int uninitialized_variable;
    printf("%d\n", uninitialized_variable);
  }
}

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  test05(); // --show-mismatched-frees
  test06(); // --error-limit 
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

    ### --xml ###
    valgrind --xml=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "\-\-xml=yes has been specified" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xml error"

    ### --xml-fd ###
    valgrind --xml=yes --xml-fd=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "xml version" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xml-fd error"

    ### --xml-file ###
    valgrind --xml=yes --xml-file=valgrind_test_xml.txt ./valgrind_test
    grep "xml version" valgrind_test_xml.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xml-file error"

    ### --xml-socket ###
    valgrind --xml=yes --xml-socket=127.0.0.1 ./valgrind_test > valgrind_test.log 2>&1
    grep "XML logging server '127.0.0.1'" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --log-socket error"

    ### --xml-user-comment ###
    valgrind --xml=yes --xml-user-comment=huawei --xml-file=valgrind_test_xml.txt ./valgrind_test
    grep "<usercomment>huawei<\/usercomment>" valgrind_test_xml.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xml-user-comment error"

    ### --demangle ###
    valgrind --demangle=no ./valgrind_test > valgrind_test.log 2>&1
    grep "operator delete\[\](void\*)" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --demangle error"

    ### --num-callers ###
    valgrind --num-callers=1 ./valgrind_test  > valgrind_test.log 2>&1
    grep -E 'by 0x[0-9a-fA-F]+: (main|[^()]+\(.*\)) \(.*\.cpp:[0-9]+\)' valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --num-callers error"

    ### --error-limit ###
    valgrind --error-limit=yes ./valgrind_test  > valgrind_test.log 2>&1
    grep "ERROR SUMMARY: 10000000 errors" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --error-limit error"

    ### --error-exitcode ###
    valgrind --error-exitcode=1 ./valgrind_test
    CHECK_RESULT $? 1 0 "execute valgrind --error-exitcode error"
    
    ### --exit-on-first-error ###
    valgrind --exit-on-first-error=yes ./valgrind_test  > valgrind_test.log 2>&1
    grep "Exit program on first error (--exit-on-first-error=yes)" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --exit-on-first-error error"

  
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
