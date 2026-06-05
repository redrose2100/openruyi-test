#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026-06-04
# @License   :   Mulan PSL v2
# @Desc      :   test tr help/case conversion/error handling functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."

    cat > /tmp/test_tr_extend << EOF
ABCDEF
abcdef
123456
EOF

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    tr --help | grep -- "--delete"
    CHECK_RESULT $? 0 0 "help option check failed"

    # upper -> lower
    tr '[:upper:]' '[:lower:]' < /tmp/test_tr_extend > /tmp/tr.result
    grep "^abcdef$" /tmp/tr.result
    CHECK_RESULT $? 0 0 "uppercase to lowercase conversion failed"

    # verify character translation result
    echo "abc123" | tr 'abc123' 'xyz789' > /tmp/tr.result
    grep "^xyz789$" /tmp/tr.result
    CHECK_RESULT $? 0 0 "character translation verification failed"

    # verify complement replacement result
    echo "abc123" | tr -c '0-9' '*' > /tmp/tr.result
    grep "^\*\*\*123\*$" /tmp/tr.result
    CHECK_RESULT $? 0 0 "complement replacement verification failed"

    # invalid option should fail
    tr --invalid-option >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid option should fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."

    rm -rf /tmp/test_tr_extend
    rm -rf /tmp/tr.result

    LOG_INFO "Finish environment cleanup!"
}

main "$@"


