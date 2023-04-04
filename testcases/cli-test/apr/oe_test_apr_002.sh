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
# @Date      :   2023.4.4
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-apr
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir -p ~/APRdir &&cd ~/APRdir

    cat > /root/APRdir/test_apr1.c  <<EOF
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
    DNF_INSTALL "apr-util-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep apr-util-devel
    CHECK_RESULT $? 0 0 "Return value error"
    cd ~/APRdir && gcc test_apr1.c -o test_apr1 -I /usr/include/apr-1 -L /usr/lib64 -lapr-1   
    ./test_apr1 > apr_test1
    test -f /root/APRdir/apr_test1 -a -f /root/APRdir/test_apr1
    CHECK_RESULT $? 0 0 "Generate test fail "
    grep "this is a test" /root/APRdir/apr_test1
    CHECK_RESULT $? 0 0 "information is error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /root/APRdir/
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
