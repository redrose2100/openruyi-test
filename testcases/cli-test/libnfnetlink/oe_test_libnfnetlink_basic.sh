#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/07
# @License   :   Mulan PSL v2
# @Desc      :   test libnfnetlink API compilation and library loading
# ############################################

# shellcheck disable=SC2119,SC2046
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnfnetlink libnfnetlink-devel gcc make"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Verify library can be loaded by dynamic linker
    ldconfig -p | grep -q "libnfnetlink"
    CHECK_RESULT $? 0 0 "libnfnetlink not found in ldconfig cache"
    
    # Compile a test program to verify library API
    cat > /tmp/test_libnfnetlink_api.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libnfnetlink/libnfnetlink.h>
#include <libnfnetlink/linux_nfnetlink.h>

int main() {
    struct nfnl_handle *h;

    /* Test nfnl_open */
    h = nfnl_open();
    if (h == NULL) {
        printf("FAIL: nfnl_open returned NULL\n");
        return 1;
    }
    printf("PASS: nfnl_open succeeded\n");

    /* Test nfnl_close */
    nfnl_close(h);
    printf("PASS: nfnl_close succeeded\n");

    printf("All API tests passed\n");
    return 0;
}
EOF
    
    gcc -o /tmp/test_libnfnetlink_api /tmp/test_libnfnetlink_api.c $(pkg-config --cflags --libs libnfnetlink)
    CHECK_RESULT $? 0 0 "Failed to compile test program"
    
    /tmp/test_libnfnetlink_api | grep "All API tests passed"
    CHECK_RESULT $? 0 0 "Test program execution failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/test_libnfnetlink_api /tmp/test_libnfnetlink_api.c
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
