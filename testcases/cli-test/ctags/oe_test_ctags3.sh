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

    LOG_INFO "Test point 3: Append mode"
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

    LOG_INFO "Test point 4: Output to stdout"
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

    LOG_INFO "Test point 5: Sort options"
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

    LOG_INFO "Test point 6: Language-specific options"
    cat > test_lang.c << 'EOF'
int c_function() {
    return 0;
}
EOF
    cat > test_lang.sh << 'EOF'
#!/bin/bash
bash_function() {
    echo "test"
}
EOF
    ctags --languages=C test_lang.c test_lang.sh
    CHECK_RESULT $? 0 0 "Failed to generate tags with language filter"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -q "c_function" tags
    CHECK_RESULT $? 0 0 "Tags file should contain C function"
    grep -q "bash_function" tags
    CHECK_RESULT $? 1 0 "Tags file should not contain shell function when filtering C only"
    rm -f tags

    LOG_INFO "Test point 7: Pattern exclusion"
    cat > test_pattern.c << 'EOF'
int pattern_function() {
    return 0;
}
EOF
    cat > test_pattern.tmp << 'EOF'
int temp_function() {
    return 0;
}
EOF
    ctags --exclude='*.tmp' test_pattern.c test_pattern.tmp
    CHECK_RESULT $? 0 0 "Failed to generate tags with pattern exclusion"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -q "pattern_function" tags
    CHECK_RESULT $? 0 0 "Tags file should contain pattern_function"
    grep -q "temp_function" tags
    CHECK_RESULT $? 1 0 "Tags file should not contain temp_function when excluding .tmp files"
    rm -f tags

    LOG_INFO "Test point 8: Extra tag fields"
    cat > test_extra.c << 'EOF'
int extra_function() {
    return 0;
}
EOF
    ctags --fields=+n test_extra.c
    CHECK_RESULT $? 0 0 "Failed to generate tags with extra fields"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -q "extra_function" tags
    CHECK_RESULT $? 0 0 "Tags file should contain extra_function"
    grep "extra_function" tags | grep -q "line:"
    CHECK_RESULT $? 0 0 "Tags file should contain line number field"
    rm -f tags

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf testdir test_file.c file1.c file2.c test_stdout.c test_sort.c test_lang.c test_lang.sh test_pattern.c test_pattern.tmp test_extra.c tags stdout_tags.txt
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
