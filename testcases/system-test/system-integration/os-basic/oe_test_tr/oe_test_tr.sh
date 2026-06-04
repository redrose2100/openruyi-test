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
# @Desc      :   test tr replace/delete/squeeze/translate functions
# ############################################

#!/usr/bin/bash

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    cat > test.txt << EOF
abc123
AAA   BBB
hello world
EOF

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    tr --help | grep -- "--delete"
    CHECK_RESULT $? 0 0 "tr --help failed"

    # replace characters
    echo "abc" | tr 'a-z' 'A-Z' > upper.txt
    grep "^ABC$" upper.txt
    CHECK_RESULT $? 0 0 "character translation failed"

    # delete characters
    echo "abc123" | tr -d '0-9' > delete.txt
    grep "^abc$" delete.txt
    CHECK_RESULT $? 0 0 "character deletion failed"

    # squeeze repeated spaces
    echo "AAA     BBB" | tr -s ' ' > squeeze.txt
    grep "^AAA BBB$" squeeze.txt
    CHECK_RESULT $? 0 0 "character squeeze failed"

    # lower to upper
    echo "hello" | tr '[:lower:]' '[:upper:]' > case.txt
    grep "^HELLO$" case.txt
    CHECK_RESULT $? 0 0 "case conversion failed"

    # upper to lower
    echo "WORLD" | tr '[:upper:]' '[:lower:]' > case2.txt
    grep "^world$" case2.txt
    CHECK_RESULT $? 0 0 "reverse case conversion failed"

    # negative case
    echo "abc" | tr -d '0-9' > negative.txt
    grep "^abc$" negative.txt
    CHECK_RESULT $? 0 0 "unexpected deletion result"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf test.txt upper.txt delete.txt squeeze.txt case.txt case2.txt negative.txt

    LOG_INFO "End to restore the test environment."
}

main "$@"

