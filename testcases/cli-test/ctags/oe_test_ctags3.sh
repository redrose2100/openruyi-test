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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2026/01/15
# @License   :   Mulan PSL v2
# @Desc      :   ctags advanced functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ctags"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "Test point 1: Exclude files and directories"
    mkdir -p testdir/excludedir testdir/includedir
    cat > testdir/file1.c << 'EOF'
int included_function() {
    return 1;
}
EOF
    cat > testdir/excludedir/file2.c << 'EOF'
int excluded_function() {
    return 2;
}
EOF
    cat > testdir/includedir/file3.c << 'EOF'
int included_function2() {
    return 3;
}
EOF
    ctags -R --exclude=excludedir testdir
    CHECK_RESULT $? 0 0 "Failed to generate tags with exclude option"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -q "included_function" tags
    CHECK_RESULT $? 0 0 "Tags file should contain included function"
    grep -q "included_function2" tags
    CHECK_RESULT $? 0 0 "Tags file should contain included function"
    grep -q "excluded_function" tags
    CHECK_RESULT $? 1 0 "Tags file should not contain excluded function"
    rm -f tags

    LOG_INFO "Test point 2: Filter tag kinds (exclude macros and variables)"
    cat > test_file.c << 'EOF'
#define MACRO_VALUE 100
int global_var = 10;
struct TestStruct {
    int field;
};
int test_function() {
    return 0;
}
EOF
    ctags --C-kinds=-d --C-kinds=-v test_file.c
    CHECK_RESULT $? 0 0 "Failed to generate tags with kind filter"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -q "test_function" tags
    CHECK_RESULT $? 0 0 "Tags file should contain function"
    grep -q "MACRO_VALUE" tags
    CHECK_RESULT $? 1 0 "Tags file should not contain macro when filtering"
    grep -q "global_var" tags
    CHECK_RESULT $? 1 0 "Tags file should not contain variable when filtering"
    rm -f tags
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf testdir test_file.c 
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

