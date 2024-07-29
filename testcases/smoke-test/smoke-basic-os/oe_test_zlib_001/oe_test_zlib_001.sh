#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuewenzhen
# @Contact   :   xuewenzhen1@huawei-partners.com
# @Date      :   2024-7-29
# @License   :   Mulan PSL v2
# @Desc      :   Test calls zlib compression and decompression interface
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc zlib-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    cat<<EOF>zlib.c
#include <stdio.h>
#include <zlib.h>

int main(int argc, char **args)
{
    /* 原始数据 */
    unsigned char strsrc[] =
        "这些是测试数据。123456789 abcdefghigklmnopqrstuvwxyz\n\t\0abcdefghijklmnopqrstuvwxyz\n"; // 包含\0字符
    unsigned char buf[1024] = {0};
    unsigned char strdst[1024] = {0};
    unsigned long srclen = sizeof(strsrc);
    unsigned long buflen = sizeof(buf);
    unsigned long dstlen = sizeof(strdst);
    int i;
    FILE *fp = NULL;
    printf("源串:");
    for (i = 0; i < srclen; ++i) {
        printf("%c", strsrc[i]);
    }
    printf("原串长度为:%ld\n", srclen);
    printf("字符串预计算长度为:%ld\n", compressBound(srclen));
    /* 压缩 */
    compress(buf, &buflen, strsrc, srclen);
    printf("压缩后实际长度为:%ld\n", buflen);
    /* 解压缩 */
    uncompress(strdst, &dstlen, buf, buflen);
    printf("目的串:");
    for (i = 0; i < dstlen; ++i) {
        printf("%c", strdst[i]);
    }
return 0;
}
EOF
    gcc -o zlib zlib.c -lz
    CHECK_RESULT $? 0 0 "compile succeed"
    LOG_INFO "Start to run test."
    ./zlib > log
    # 验证压缩前后长度对比
    length_forward=$(sed -n '3p' log | awk -F ":" '{print $2}')
    length_Rear=$(sed -n '5p' log | awk -F ":" '{print $2}')
    test "$length_forward" -gt "$length_Rear"
    CHECK_RESULT $? 0 0 "The lengths before and after compression are not equal"
    # 验证压缩前后数据变化
    Data_forward=$(sed -n '1p' log | awk -F "。" '{print $2}')
    Date_Rear=$(sed -n '6p' log | awk -F "。" '{print $2}')
    test "$Data_forward" = "$Date_Rear"
    CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
    Data_forward=$(sed -n '2p' log | awk -F "a" '{print $2}')
    Date_Rear=$(sed -n '7p' log | awk -F "a" '{print $2}')
    test "$Data_forward" = "$Date_Rear"
    CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf log zlib
    LOG_INFO "End to restore the test environment."
}

main $@