#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangjiayu01
# @Contact   :   liangjiayu@uniontech.com
# @Date      :   2024-06-27
# @License   :   Mulan PSL v2
# @Desc      :   test c++ stl 
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > teststl.cpp << EOF
#include <iostream>
#include <vector>
#include <string>
#include <deque>
using namespace std;
int main()
{
vector<int> test1;
test1.push_back(1);
string res;
if(test1[0]==1)
{
  res="Hello STL!";
}

cout << res << endl;
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error, fail to create teststl.cpp"
    g++  teststl.cpp -o teststl
    CHECK_RESULT $? 0 0 "Error, fail to create teststl"
    ./teststl | grep "Hello STL!"
    LOG_INFO "End teststl!"
}

function post_test() {
    LOG_INFO "start environment!"
    DNF_REMOVE "$@"
    rm -rf teststl teststl.cpp
    LOG_INFO "end environment!"
}

main "$@"

