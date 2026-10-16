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
# @Date      :   2023.8.7
# @License   :   Mulan PSL v2
# @Desc      :   binutils-objcopy formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc-c++"
cat > /tmp/test.cpp << EOF
#include<stdio.h>
int divide(int x, int y)
{
return x/y;
}
int main()
{
printf("hello world\n");
int x = 3;
int y = 0;
int div = divide(x, y);
printf("%d / %d = %d\n", x, y, div);
return 0;
}
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp &&  g++ -Wl,-Map=test.map -g test.cpp -o test
    test -f /tmp/test.map -a /tmp/test
    CHECK_RESULT $? 0 0 "compile test.cpp fail"    
    file1=$(wc -c /tmp/test |awk '{print $1}')
    strip /tmp/test
    file2=$(wc -c /tmp/test |awk '{print $1}')
    [ "$file1" -gt "$file2" ] 
    CHECK_RESULT $? 0 0 "test file error"   
    objcopy -O srec test test.srec
    head /tmp/test.srec > testfile
    grep "S00C0000746573742E7372656358" /tmp/test.srec
    CHECK_RESULT $? 0 0 "test.srec file error"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testfile /tmp/test /tmp/test.cpp /tmp/test.map /tmp/test.srec
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
