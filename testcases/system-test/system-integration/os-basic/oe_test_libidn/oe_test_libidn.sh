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
# @Author    :   Elvis-surfing
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023-11-20
# @License   :   Mulan PSL v2
# @Desc      :   libidn编译支持
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libidn* gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cat > /tmp/test.c << EOF
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <idn2.h>

    int main() {
       const char *input = "müller";
       char *output;
       int ret;

    // 转换字符串
       ret = idn2_to_ascii_8z(input, &output, IDN2_NONTRANSITIONAL);
       if (ret != IDN2_OK) {
        fprintf(stderr, "无法转换字符串\n");
        exit(EXIT_FAILURE);
    }
    // 打印转换结果
       printf("转换结果: %s\n", output);
    // 释放资源
       idn2_free(output);
       return 0;
   }
EOF
    gcc -o /tmp/test /tmp/test.c -lidn2
    CHECK_RESULT $? 0 0 "File compilation failed"
    /tmp/test || grep "转换结果: xn--mller-kva" 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test
    rm -rf /tmp/test.c
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

