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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.8.4
# @License   :   Mulan PSL v2
# @Desc      :   g++ formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc-c++"
cat > /tmp/helloworld.cpp << EOF
/* helloworld.cpp */
#include <iostream>
int main(int argc,char *argv[])
{
std::cout << "hello, world" << std::endl;
return(0);
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep gcc-c++
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && g++  helloworld.cpp
    test -f /tmp/a.out
    CHECK_RESULT $? 0 0 "compile helloworld.cpp fail"    
    ./a.out > /tmp/test
    grep "hello, world" /tmp/test
    CHECK_RESULT $? 0 0 "compile a.out error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test /tmp/helloworld.cpp /tmp/a.out
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
