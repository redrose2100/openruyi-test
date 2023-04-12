#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Use nss case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pwd=`pwd`
    mkdir c_stat_test && cd c_stat_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > haha.c << EOF
#include <sys/stat.h>
#include <sys/stat.h>
void haha(struct stat *fileinfo)
{
if(stat("./teststat.c",fileinfo) == 0){
return;
}
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create haha.c"
    cat > teststat.c << EOF
#include<sys/stat.h>
#include <stdio.h>
int main()
{
struct stat fileinfo;
haha(&fileinfo);
printf("st_size=%d\n",fileinfo.st_size);
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create teststat.c"
    gcc --shared -fpic -o haha.so haha.c
    CHECK_RESULT $? 0 0 "Error,fail to create haha.so"
    gcc -o teststat teststat.c ./haha.so
    CHECK_RESULT $? 0 0 "Error,fail to create teststat"
    gcc -D_FILE_OFFSET_BITS=64 -o teststat64 teststat.c ./haha.so
    CHECK_RESULT $? 0 0 "Error,fail to create teststat64"
    result=`./teststat`
    CHECK_RESULT $? 0 0 "Error,check the file teststat"
    ./teststat64 | grep $result
    CHECK_RESULT $? 0 0 "Error,check the file teststat64"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $pwd && rm -rf c_stat_test/
    LOG_INFO "End to restore the test environment."
}

main "$@"