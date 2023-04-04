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
# @Date      :   2023-04-03
# @License   :   Mulan PSL v2
# @Desc      :   Use usermod case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "apr-util-devel"
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    mkdir APRdir && cd APRdir
    cat > test_apr1.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <apr_general.h>
//#include <apr_pools.h>
#define MEM_ALLOC_SZ 1024
int main(int argc, const char * const argv[])
{
apr_pool_t * pool;//内存池
apr_status_t rv;
char * buf;
rv = apr_initialize();//初始化
if( rv != APR_SUCCESS ){
return -1;
}
rv = apr_pool_create(&pool,NULL);//创建内存池
if( rv != APR_SUCCESS ){
return -1;
}
buf = apr_palloc(pool,MEM_ALLOC_SZ);//分配一个内存块
//apr_pool_clear(pool);
strcpy(buf,"test");
printf("this is a %s\n",buf);
apr_pool_destroy(pool);//销掉内存池对象
apr_terminate();//结束
return APR_SUCCESS;
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create test_apr1.c"
    gcc test_apr1.c -o test_apr1 -I /usr/include/apr-1 -L /usr/lib64 -lapr-1
    CHECK_RESULT $? 0 0 "Fail to create test_apr1"
    ./test_apr1 | grep  "this is a test"
    CHECK_RESULT $? 0 0 "Error,can't use test_apr1"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf APRdir/
    LOG_INFO "End to restore the test environment."
}

main "$@"