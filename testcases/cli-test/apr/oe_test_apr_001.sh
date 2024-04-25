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
    mkdir -p ~/apr && cd ~/apr || return
    cat > /root/apr/test  <<EOF
hello apr ...
EOF

    cat > /root/apr/test_apr.c  <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <apr_general.h>
#include <apr_pools.h>
#include <apr_file_io.h>
#define MEM_ALLOC_SIZE 1024
int main(int argc, const char * const argv[])
{
apr_pool_t *pool;       //内存池
apr_status_t rv;
char *buf;
char *contentBuf;
apr_file_t *fin;
apr_file_t *fout;
apr_size_t len;
apr_finfo_t finfo;      //用来保存文件信息的结构体
rv = apr_initialize();  //初始化
rv = apr_pool_create(&pool, NULL);      //创建pool
buf = apr_palloc(pool, MEM_ALLOC_SIZE); //给buf分配空间
rv = apr_file_open(&fin, "/root/apr/test", APR_READ | APR_BUFFERED, APR_OS_DEFAULT, pool);       //打开可读文件
if (rv == APR_SUCCESS) {
strcpy(buf, "fileread_open succeed!");
printf("this is a test:%s\\n", buf);
}
apr_file_lock(fin, APR_FLOCK_SHARED);   //读锁,允许其他读者进线程对它读，但不能有写者对它操作
/*
* 打开可写文件
* 其中APR_CREATE表示若没有该文件则创建一个，APR_TRUNCATE表示若文件有内容则全部删掉（APR_APPEND为在文件末添加）
*/
rv = apr_file_open(&fout, "/root/apr/test", APR_WRITE | APR_BUFFERED | APR_CREATE | APR_TRUNCATE, APR_OS_DEFAULT, pool);
if (rv == APR_SUCCESS) {
strcpy(buf, "filewrite_open succeed!");
printf("this is a test:%s\\n", buf);
}
apr_file_lock(fout, APR_FLOCK_EXCLUSIVE);       //写锁，不允许其他进程对此文件操作
/*
* 将test_apr1.c文件中的内容全部复制到test_write.c文件中
*/
contentBuf = apr_palloc(pool, MEM_ALLOC_SIZE);
do{
apr_file_read(fin, contentBuf, &len);
//contentBuf[len] = 0;
apr_file_write(fout, contentBuf, &len);
} while(len != 0);
//关闭文件test_apr1.c
apr_file_unlock(fin);
apr_file_close(fin);
/*
* 将复制test_apr1.c为test_apr1_bak.c，同时删掉test_apr1.c文件
*/
apr_file_copy("/root/apr/test", "/root/apr/test_bak", APR_OS_DEFAULT, pool);
apr_file_remove("/root/apr/test", pool);
apr_file_info_get(&finfo, APR_FINFO_NAME, fout);        //获取文件信息方法1：通过文件对象
printf("file name is:%s\\n", finfo.fname);
apr_stat(&finfo,"/root/apr/test_bak", APR_FINFO_SIZE, pool);     //获取文件信息方法2：通过文件路径
printf("file size is:%d bytes\\n", finfo.size);
//关闭文件test_write.c
apr_file_unlock(fout);
apr_file_close(fout);
apr_pool_destroy(pool);         //销掉内存池对象
apr_terminate();        //结束
return APR_SUCCESS;
}
EOF
    DNF_INSTALL "apr-util-devel gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep apr-util-devel
    CHECK_RESULT $? 0 0 "Return value error"
    cd ~/apr && gcc test_apr.c -o test_apr -I /usr/include/apr-1 -L /usr/lib64 -l apr-1
    ./test_apr > apr_test
    test -f /root/apr/apr_test -a -f /root/apr/test_apr -a -f /root/apr/test_bak
    CHECK_RESULT $? 0 0 "Generate test fail "
    grep "this is a test:fileread_open succeed!" /root/apr/apr_test
    CHECK_RESULT $? 0 0 "information is error"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /root/apr/
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
