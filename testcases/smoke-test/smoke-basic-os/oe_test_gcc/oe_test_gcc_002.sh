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
# @Date      :   2023.4.12
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

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd ${path2}&&gcc person.cpp -fpic -shared -o libperson.so
    test -f ${path2}/libperson.so
    CHECK_RESULT $? 0 0 "libperson file fails"
    cd ${path1}&&g++ main.cpp -o main -I../person -L../person -lperson
    test -f ${path1}/main
    CHECK_RESULT $? 0 0 "main file fails"
    export LD_LIBRARY_PATH=../person
    ./main > main.txt
    grep "test g++" ${path1}/main.txt
    CHECK_RESULT $? 0 0 "main.txt file fails"
    ldd main > lddmain.txt
    grep "linux-vdso.so.1" ${path1}/lddmain.txt
    CHECK_RESULT $? 0 0 "lddmain.txt file fails"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path1} ${path2}
    
    LOG_INFO "Finish environment cleanup!"
}

main $@
