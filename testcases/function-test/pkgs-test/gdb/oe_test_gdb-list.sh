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
# @Date      :   2023.8.25
# @License   :   Mulan PSL v2
# @Desc      :   gdb-list formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc-c++ gdb"
    cat > /tmp/add.c << EOF
#include <stdio.h>
int add(int x,int y)
{
return x+y;
}
int main()
{
int x = 10;
int y = 20;
int num = add(x,y);
printf("num=%d\n",num);
return 0;
}
EOF

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep gdb
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc -g add.c
    test -f /tmp/a.out
    CHECK_RESULT $? 0 0 "compile add.c fail"
    gdb /tmp/a.out<< EOF >>/tmp/add.log 2>&1
help
list 4
l main
disassemble add
disassemble main
q
EOF
    grep "0x000000" /tmp/add.log
    CHECK_RESULT $? 0 0 "certifi_test file error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/add.log /tmp/a.out /tmp/add.c
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

