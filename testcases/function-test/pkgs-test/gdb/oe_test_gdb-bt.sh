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
# @Date      :   2023.8.24
# @License   :   Mulan PSL v2
# @Desc      :   gdb-bt formatting test
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL gdb
    cat>/tmp/test.c<<EOF
#include <stdio.h>
int add(int a,int b)
{
return a+b;
}
int main()
{
int sum[10];
int i;
int array1[10] =
{
48,56,77,33,33,11,226,544,78,90
};
int array2[10] =
{
85,99,66,0x199,393,11,1,2,3,4
};
for(i=0; i<10; i++)
{
sum[i] = add(array1[i],array2[i]);
}
return 0;
}
EOF

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep gdb
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc test.c -g -o test
    test -f /tmp/test
    CHECK_RESULT $? 0 0 "compile test.c fail"    
    gdb /tmp/test<< EOF >>/tmp/test.log 2>&1
start
bt
bt full
info f
info registers
EOF
    if [ "$(uname -m)"x == "riscv64x" ]; then
        grep "gp" /tmp/test.log
    elif [ "$(uname -m)" == "armv7l" ] || [ "$(uname -m)" == "aarch64" ]; then
        grep "cpsr" /tmp/test.log
    else
        grep "rax" /tmp/test.log
    fi
    CHECK_RESULT $? 0 0 "certifi_test file error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.log /tmp/test /tmp/test.c
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
