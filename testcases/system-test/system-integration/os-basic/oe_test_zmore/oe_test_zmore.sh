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
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-06-11
#@License       :   Mulan PSL v2
#@Desc          :   Test case for zmore command
#####################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {  
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL gzip
    cat > test_zmore.txt << EOF
Line 1
Line 2
Line 3
Line 4
Line 5
EOF
    cp test_zmore.txt test_zmore_compress.txt
    gzip test_zmore_compress.txt
    CHECK_RESULT $? 0 0 "Failed to compress test file"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    zmore --help > zmore_help.out 2>&1
    CHECK_RESULT $? 0 0 "zmore --help exited with non-zero code"
    grep -q "Like 'more', but operate" zmore_help.out
    CHECK_RESULT $? 0 0 "zmore help output missing expected content"

    zmore test_zmore_compress.txt.gz | grep -q "Line 3"
    CHECK_RESULT $? 0 0 "zmore failed to extract and display content from compressed file"

    zmore test_zmore.txt | grep -q "Line 2"
    CHECK_RESULT $? 0 0 "zmore failed to display content from uncompressed file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test_zmore* zmore_help.out
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
