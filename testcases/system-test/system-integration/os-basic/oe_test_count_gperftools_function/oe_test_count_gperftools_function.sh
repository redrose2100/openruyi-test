#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023-04-04
# @License   :   Mulan PSL v2
# @Desc      :   gperftools-功能验证
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "gperftools"
    LOG_INFO "End of environmental preparation!"

}

function run_test() {
    LOG_INFO "Start to run test."
    cat >test.cpp <<EOF
#include <gperftools/profiler.h>
#include <iostream>
using namespace std;
void func1() {
int i = 0;
while (i < 100000) {
++i;
}
}
void func2() {
int i = 0;
while (i < 200000) {
++i;
}
}
void func3() {
for (int i = 0; i < 1000; ++i) {
func1();
func2();
}
}
int main(){
func3();
return 0;
}
EOF
    test -f test.cpp
    CHECK_RESULT $? 0 0 "File creation failed"
    g++ test.cpp -o main -lprofiler
    test -f main
    CHECK_RESULT $? 0 0 "File creation failed"
    CPUPROFILE=./main.prof ./main
    test -f main.prof
    CHECK_RESULT $? 0 0 "File creation failed"
    pprof ./main main.prof --pdf > main.pdf
    test -f main.pdf
    CHECK_RESULT $? 0 0 "File creation failed"
    pprof ./main main.prof --text
    CHECK_RESULT $? 0 0 "Output failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf main* test.cpp
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"

}
main "$@"
