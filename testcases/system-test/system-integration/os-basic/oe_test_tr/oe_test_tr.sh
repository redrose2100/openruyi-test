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
# @Desc      :   test tr help/version/translate/delete/squeeze functions
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

    # version
    tr --version | grep "coreutils"
    CHECK_RESULT $? 0 0 "tr --version failed"

    # delete characters
    echo "abc123" | tr -d '0-9' > delete.txt
    grep "^abc$" delete.txt
    CHECK_RESULT $? 0 0 "character deletion failed"

    # squeeze repeated spaces
    echo "AAA     BBB" | tr -s ' ' > squeeze.txt
    grep "^AAA BBB$" squeeze.txt
    CHECK_RESULT $? 0 0 "character squeeze failed"

    # lower to upper
    echo "hello world" | tr '[:lower:]' '[:upper:]' > upper.txt
    grep "^HELLO WORLD$" upper.txt
    CHECK_RESULT $? 0 0 "lower to upper conversion failed"

    # upper to lower
    echo "HELLO WORLD" | tr '[:upper:]' '[:lower:]' > lower.txt
    grep "^hello world$" lower.txt
    CHECK_RESULT $? 0 0 "upper to lower conversion failed"

    # multiple character translation
    echo "abc" | tr 'abc' 'xyz' > translate.txt
    grep "^xyz$" translate.txt
    CHECK_RESULT $? 0 0 "character translation failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf test.txt \
        delete.txt \
        squeeze.txt \
        upper.txt \
        lower.txt \
        translate.txt

    LOG_INFO "End to restore the test environment."
}

main "$@"

