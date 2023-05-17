#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023-03-27
# @License   :   Mulan PSL v2
# @Desc      :   Use c++ to compile c programs
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > test.cpp << EOF
#include <iostream>
using namespace std;
int main()
{
cout << "Hello C++!\n" << endl;
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Error, fail to create test.cpp"
    g++  test.cpp -o test
    CHECK_RESULT $? 0 0 "Error, fail to create test"
    ./test
    CHECK_RESULT $? 0 0 "Error, please check 'hello C++'"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test test.cpp
    LOG_INFO "Finish environment cleanup!"
}

main $@
