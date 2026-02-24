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
# @Date      :   2026/02/24
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

    LOG_INFO "Test point 1: Append mode"
    cat > file1.c << 'EOF'
int function1() {
    return 1;
}
EOF
    cat > file2.c << 'EOF'
int function2() {
    return 2;
}
EOF
    ctags file1.c
    CHECK_RESULT $? 0 0 "Failed to generate initial tags"
    grep -q "function1" tags
    CHECK_RESULT $? 0 0 "Initial tags should contain function1"
    ctags -a file2.c
    CHECK_RESULT $? 0 0 "Failed to append tags"
    grep -q "function1" tags
    CHECK_RESULT $? 0 0 "Tags file should still contain function1 after append"
    grep -q "function2" tags
    CHECK_RESULT $? 0 0 "Tags file should contain function2 after append"
    rm -f tags

    LOG_INFO "Test point 2: Output to stdout"
    cat > test_stdout.c << 'EOF'
int stdout_function() {
    return 0;
}
EOF
    ctags -o - test_stdout.c > stdout_tags.txt
    CHECK_RESULT $? 0 0 "Failed to output tags to stdout"
    test ! -f tags
    CHECK_RESULT $? 0 0 "Default tags file should not be created when using stdout"
    test -f stdout_tags.txt
    CHECK_RESULT $? 0 0 "Stdout tags file should be created"
    grep -q "stdout_function" stdout_tags.txt
    CHECK_RESULT $? 0 0 "Stdout tags should contain function"
    rm -f stdout_tags.txt

    LOG_INFO "Test point 3: Sort options"
    cat > test_sort.c << 'EOF'
int zebra_function() {
    return 0;
}
int alpha_function() {
    return 0;
}
int beta_function() {
    return 0;
}
EOF
    ctags --sort=yes test_sort.c
    CHECK_RESULT $? 0 0 "Failed to generate sorted tags"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    alpha_line=$(grep -n "alpha_function" tags | cut -d: -f1)
    beta_line=$(grep -n "beta_function" tags | cut -d: -f1)
    zebra_line=$(grep -n "zebra_function" tags | cut -d: -f1)
    if [ "$alpha_line" -lt "$beta_line" ] && [ "$beta_line" -lt "$zebra_line" ]; then
        CHECK_RESULT $? 0 0 "Tags should be sorted alphabetically"
    else
        CHECK_RESULT $? 1 0 "Tags are not sorted correctly"
    fi
    rm -f tags


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf  file1.c file2.c test_stdout.c  test_sort.c stdout_tags.txt
    LOG_INFO "Finish restoring the test environment."
}

main "$@"