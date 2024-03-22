#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2023/11/02
# @License   :   Mulan PSL v2
# @Desc      :   Test libtommath function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "libtommath libtommath-devel libtommath-help gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >example.c <<EOF
#include <tommath.h>
#include <stdio.h>

int main(void) {
    mp_int a, b, c;
    int err;

    // 初始化大整数 a 和 b
    mp_init(&a);
    mp_init(&b);
    err = mp_read_radix(&a, "1234567890", 10);
    err = mp_read_radix(&b, "9876543210", 10);
    if (err != MP_OKAY) {
        printf("Failed to input numbers, error code: %d\n", err);
        return 1;
    }

    // 大整数相加
    mp_init(&c);
    err = mp_add(&a, &b, &c);
    if (err != MP_OKAY) {
        printf("Addition failed, error code: %d\n", err);
        return 1;
    }

    // 输出结果
    char buf[100];
    mp_toradix(&c, buf, 10);
    printf("Result: %s\n", buf);

    // 清理资源
    mp_clear_multi(&a, &b, &c, NULL);

    return 0;
}
EOF
    test -f example.c
    CHECK_RESULT $? 0 0 "Create example.c file fail"
    gcc example.c -o example -ltommath
    test -f example
    CHECK_RESULT $? 0 0 "Create example file fail"
    ./example | grep "Result: 11111111100"
    CHECK_RESULT $? 0 0 "Execution failed"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf example.c example
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
