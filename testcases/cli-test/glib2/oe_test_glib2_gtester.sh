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
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gtester command
# ############################################

# shellcheck disable=SC2119,SC2046
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 gcc glib2-devel"
    # Create a simple test program
    cat > /tmp/test_gtester.c << 'EOF'
#include <glib.h>

void test_sample(void) {
    g_assert(TRUE);
}

void test_another(void) {
    g_assert(1 + 1 == 2);
}

int main(int argc, char *argv[]) {
    g_test_init(&argc, &argv, NULL);
    g_test_add_func("/test/sample", test_sample);
    g_test_add_func("/test/another", test_another);
    return g_test_run();
}
EOF
    gcc /tmp/test_gtester.c -o /tmp/test_gtester $(pkg-config --cflags --libs glib-2.0)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test --help (only one help test)
    gtester --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gtester --help check failed"
    
    # Test --version
    gtester --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "gtester --version check failed"
    
    # Test --verbose
    gtester --verbose /tmp/test_gtester  | grep -C 3 "/test/sample" | grep "/test/another"
    CHECK_RESULT $? 0 0 "gtester --verbose check failed"
    
    # Test -l (list test paths)
    gtester -l /tmp/test_gtester  | grep "/test"
    CHECK_RESULT $? 0 0 "gtester -l check failed"
    
    # Test -m quick
    gtester -m quick /tmp/test_gtester | grep "TEST: /tmp/test_gtester"
    CHECK_RESULT $? 0 0 "gtester -m quick check failed"
    
    # Test -p (run specific test)
    gtester -p=/test/sample --verbose /tmp/test_gtester | grep "/test/sample"
    CHECK_RESULT $? 0 0 "gtester -p check failed"
    gtester -p=/test/sample --verbose /tmp/test_gtester | grep "/test/another"
    CHECK_RESULT $? 0 1 "gtester -p check failed"
    
    # Test -s -o (skip specific test and output log file)
    gtester -s=/test/another -o=/tmp/test_log.xml /tmp/test_gtester
    CHECK_RESULT $? 0 0 "gtester -s check failed"
    grep -A 2 "/test/another" /tmp/test_log.xml | grep "exit-status=\"1\""
    CHECK_RESULT $? 0 0 "gtester -o file check failed"
    
    # Test -k (keep going)
    gtester -k /tmp/test_gtester | grep -E "TEST:|OK"
    CHECK_RESULT $? 0 0 "gtester -k check failed"
    
    # Test --quiet
    gtester --quiet /tmp/test_gtester 2>&1 | grep "TEST: /tmp/test_gtester"
    CHECK_RESULT $? 0 1 "gtester --quiet check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_gtester.c /tmp/test_gtester /tmp/test_log.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"