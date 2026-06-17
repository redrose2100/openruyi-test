#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   caowenqian
#@Contact       :   caowenqian@uniontech.com
#@Date          :   2026-06-15
#@License       :   Mulan PSL v2
#@Desc          :   Test case for ranlib command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    testDir=$(mktemp -d)
    cat > "$testDir/test.c" <<EOF
int foo() { return 42; }
EOF
    gcc -c "$testDir/test.c" -o "$testDir/test.o"
    ar cr "$testDir/test.a" "$testDir/test.o"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    # Test ranlib help option
    ranlib --help 2>&1 | grep -q "ranlib"
    CHECK_RESULT $? 0 0 "ranlib --help failed"
    
    # Test basic ranlib (add index)
    ranlib "$testDir/test.a"
    CHECK_RESULT $? 0 0 "ranlib basic run failed"
    
    # Verify index exists using nm -s
    nm -s "$testDir/test.a" | grep -q "foo"
    CHECK_RESULT $? 0 0 "ranlib did not create symbol index"
    
    # Test -D (deterministic timestamp)
    ranlib -D "$testDir/test.a"
    CHECK_RESULT $? 0 0 "ranlib -D failed"
    
    # Test -U (non-deterministic timestamp)
    ranlib -U "$testDir/test.a"
    CHECK_RESULT $? 0 0 "ranlib -U failed"
    
    # Test -t (update timestamp)
    ranlib -t "$testDir/test.a"
    CHECK_RESULT $? 0 0 "ranlib -t failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    rm -rf "$testDir"
    LOG_INFO "End to restore the test environment."
}

main "$@"
