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
# @Date      :   2023.4.11
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-gcc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir -p /tmp/test /tmp/person
    path1=/tmp/test
    path2=/tmp/person
    cat > ${path1}/main.cpp  <<EOF
#include<iostream>
#include "person.h"
using namespace std;
int main(int argc,char* argv[])
{
person p;
cout<<"test g++"<<endl;
return 0;
}
EOF

     cat > ${path2}/person.h  <<EOF
class person
{
public:
person();
};
EOF

     cat > ${path2}/person.cpp  <<EOF
#include "person.h"
#include "stdio.h"
person::person()
{
printf("create person\n");
}
EOF

    DNF_INSTALL "glibc-static libstdc++-static"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd ${path2}&&g++ -c ${path2}/person.cpp
    test -f ${path2}/person.o
    CHECK_RESULT $? 0 0 "person file fails"
    cd ${path1}&&g++ main.cpp ../person/person.o -I ../person/ -o main
    test -f ${path1}/main
    CHECK_RESULT $? 0 0 "main file fails"
    ./main > main.txt
    grep "test g++" ${path1}/main.txt
    CHECK_RESULT $? 0 0 "main.txt file fails"
    ldd main > main.txt1
    grep "libstdc++.so.6" ${path1}/main.txt1
    CHECK_RESULT $? 0 0 "ldd main file fails"
    cd ${path1}&&g++ main.cpp ../person/person.o -o main_static -I ../person/ -static
    test -f ${path1}/main_static
    CHECK_RESULT $? 0 0 "main_static file fails"
    ldd main_static > main_static.txt
    grep "not a dynamic executable" ${path1}/main_static.txt
    CHECK_RESULT $? 0 0 "ldd main_static file fails"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path1} ${path2}
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
