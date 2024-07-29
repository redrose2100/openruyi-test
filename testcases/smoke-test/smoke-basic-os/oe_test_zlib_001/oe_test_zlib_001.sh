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
# @Date      :   2024.7.29
# @License   :   Mulan PSL v2
# @Desc      :   Test calls zlib compression and decompression interface
# ############################################
#shellcheck disable=SC1091,SC1017

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
    unsigned char str[] =
        "这些是测试数据。123456789 abcdefghigklmnopqrstuvwxyz\n\t\0abcdefghijklmnopqrstuvwxyz\n"; // 包含\0字符
    unsigned long srclen = sizeof(str);
    unsigned char buf[1024] = {0};
    unsigned long buflen = sizeof(buf);
    unsigned char dst[1024] = {0};
    unsigned long dstlen = sizeof(dst);
    int i;
    FILE *fp = NULL;
    printf("源串:");
    for (i = 0; i < srclen; ++i) {
        printf("%c", str[i]);
    }
    printf("源串长度为:%ld\n", srclen);
    printf("字符串预计算长度为:%ld\n", compressBound(srclen));
    /* 压缩 */
    compress(buf, &buflen, str, srclen);
    printf("压缩后实际长度为:%ld\n", buflen);
    /* 解压缩 */
    uncompress(dst, &dstlen, buf, buflen);
    printf("目的串:");
    for (i = 0; i < dstlen; ++i) {
        printf("%c", str[i]);
    }
    return 0;
}
EOF
    gcc -o zlib zlib.c -lz
    CHECK_RESULT $? 0 0 "compile succeed"
    LOG_INFO "Start to run test."
    ./zlib > log
    LOG_INFO "Start testing..."
    # 验证压缩前后长度对比
    length_forward=$(sed -n '3p' test.txt | awk -F ":" '{print $2}')
    length_Rear=$(sed -n '5p' test.txt | awk -F ":" '{print $2}')
    test "$length_forward" -gt "$length_Rear"
    CHECK_RESULT $? 0 0 "The lengths before and after compression are not equal"
    # 验证压缩前后数据变化
    Data_forward=$(sed -n '1p' test.txt | awk -F "。" '{print $2}')
    Date_Rear=$(sed -n '6p' test.txt | awk -F "。" '{print $2}')
    test "$Data_forward" = "$Date_Rear"
    CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
    Data_forward=$(sed -n '2p' test.txt | awk -F "a" '{print $2}')
    Date_Rear=$(sed -n '7p' test.txt | awk -F "a" '{print $2}')
    test "$Data_forward" = "$Date_Rear"
    CHECK_RESULT $? 0 0 "Data is inconsistent before and after compression"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"