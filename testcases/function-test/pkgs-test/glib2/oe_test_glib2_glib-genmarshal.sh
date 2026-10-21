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
# @Desc      :   test glib-genmarshal command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glib2 glib2-devel"
    echo 'VOID:STRING' > /tmp/test_std.list
    echo 'VOID:POINTER,UINT' > /tmp/test_custom.list
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    glib-genmarshal --help | grep -i "usage:"
    CHECK_RESULT $? 0 0 "glib-genmarshal --help check failed"
    
    # Test --version
    glib-genmarshal --version | grep "$(rpm -q glib2 | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "glib-genmarshal --version check failed"
    
    # Test --prefix with --header
    glib-genmarshal --prefix=test --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal --prefix check failed"
    
    # Test --output
    glib-genmarshal --prefix=test --output=/tmp/test_marshal.h --header /tmp/test_std.list 2>&1
    CHECK_RESULT $? 0 0 "glib-genmarshal --output check failed"
    grep -q "test_VOID__STRING" /tmp/test_marshal.h
    CHECK_RESULT $? 0 0 "glib-genmarshal --output content check failed"
    
    # Test --skip-source
    glib-genmarshal --prefix=test --skip-source --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal --skip-source check failed"
    
    # Test --internal
    glib-genmarshal --prefix=test --internal --header /tmp/test_custom.list 2>&1 | grep "G_GNUC_INTERNAL"
    CHECK_RESULT $? 0 0 "glib-genmarshal --internal check failed"
    
    # Test --valist-marshallers
    glib-genmarshal --prefix=test --valist-marshallers --header /tmp/test_std.list 2>&1 | grep "STRINGv"
    CHECK_RESULT $? 0 0 "glib-genmarshal --valist-marshallers check failed"
    
    # Test --pragma-once
    glib-genmarshal --prefix=test --pragma-once --header /tmp/test_std.list 2>&1 | grep "pragma once"
    CHECK_RESULT $? 0 0 "glib-genmarshal --pragma-once check failed"
    
    # Test --include-header with --body
    glib-genmarshal --prefix=test --include-header=test_marshal.h --body /tmp/test_std.list 2>&1 | grep "test_marshal.h"
    CHECK_RESULT $? 0 0 "glib-genmarshal --include-header check failed"
    
    # Test --prototypes with --body
    glib-genmarshal --prefix=test --prototypes --body /tmp/test_custom.list 2>&1 | grep "void test_VOID__POINTER_UINT"
    CHECK_RESULT $? 0 0 "glib-genmarshal --prototypes check failed"
    
    # Test --header
    glib-genmarshal --prefix=test --header /tmp/test_std.list 2>&1 | grep "__TEST_MARSHAL_H__"
    CHECK_RESULT $? 0 0 "glib-genmarshal --header check failed"
    
    # Test --body
    glib-genmarshal --prefix=test --body /tmp/test_custom.list 2>&1 | grep "test_VOID__POINTER_UINT"
    CHECK_RESULT $? 0 0 "glib-genmarshal --body check failed"
    
    # Test --stdinc
    glib-genmarshal --prefix=test --stdinc --header /tmp/test_std.list 2>&1 | grep "g_cclosure_marshal"
    CHECK_RESULT $? 0 0 "glib-genmarshal --stdinc check failed"
    
    # Test --nostdinc
    glib-genmarshal --prefix=test --nostdinc --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal --nostdinc check failed"
    
    # Test --quiet
    glib-genmarshal --prefix=test --quiet --header /tmp/test_std.list 2>&1 | grep -c "INFO"
    CHECK_RESULT $? 0 1 "glib-genmarshal --quiet check failed"
    
    # Test --verbose
    glib-genmarshal --prefix=test --verbose --header /tmp/test_std.list 2>&1 | grep "INFO"
    CHECK_RESULT $? 0 0 "glib-genmarshal --verbose check failed"
    
    # Test --g-fatal-warnings
    glib-genmarshal --prefix=test --g-fatal-warnings --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal --g-fatal-warnings check failed"
    
    # Test -D (preprocessor define)
    glib-genmarshal --prefix=test -DTEST_DEFINE --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal -D check failed"
    
    # Test -U (preprocessor undefine)
    glib-genmarshal --prefix=test -UTEST_UNDEF --header /tmp/test_std.list 2>&1 | grep "test_VOID__STRING"
    CHECK_RESULT $? 0 0 "glib-genmarshal -U check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f /tmp/test_std.list /tmp/test_custom.list /tmp/test_marshal.h
    LOG_INFO "End to restore the test environment."
}

main "$@"
