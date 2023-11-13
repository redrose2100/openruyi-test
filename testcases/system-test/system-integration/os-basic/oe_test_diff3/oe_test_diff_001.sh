#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-14
# @License   :   Mulan PSL v2
# @Desc      :   Use diff_001 case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "diffutils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir test1 && echo "aaa" > test1/file
    mkdir test2 && echo "aab" > test2/file
    CHECK_RESULT $? 0 0 "Error, Fail to create test1/file or test2/file"
    diff -r test1/ test2/ > result
    CHECK_RESULT $? 1 0 "Error,Fail to create log"
    cat > expected<< EOF
diff -r test1/file test2/file
1c1
< aaa
---
> aab
EOF
    CHECK_RESULT $? 0 0 "Error,Check test1/file or test2/file"
    cmp -s "result" "expected"
    CHECK_RESULT $? 0 0 "Error,Check test1/file or test2/file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test1 test2 result expected
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"