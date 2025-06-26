#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-06-25
# @License   :   Mulan PSL v2
# @Desc      :   command ab04
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl start httpd
    TEST_DIR="/var/www/html/ab_test"
    mkdir -p "$TEST_DIR"
    TEST_FILE="$TEST_DIR/test.html"
    echo "Hello, World!" | sudo tee "$TEST_FILE" >/dev/null
    POST_DATA="$TEST_DIR/post_data.txt"
    echo "key1=value1&key2=value2" | sudo tee "$POST_DATA" >/dev/null
    DYNAMIC_FILE="$TEST_DIR/dynamic.php"
    tee "$DYNAMIC_FILE" >/dev/null <<'EOF'
<?php echo time(); ?>
EOF
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    TMP_DIR=$(mktemp -d)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    BASE_URL="http://localhost/ab_test/test.html"
    ab -n 1 -C "session=12345" "$BASE_URL" | grep ab_test
    CHECK_RESULT $? 0 0 "Test -C option (cookie)"
    ab -n 1 -H "X-Test: ab-test" "$BASE_URL" | grep ab_test
    CHECK_RESULT $? 0 0 "Test -H option (custom header)"
    ab -V 2>&1 | grep "ApacheBench"
    CHECK_RESULT $? 0 0 "Test -V option (version info)"
    ab -n 10 -d "$BASE_URL" | grep -v "Percentage of the requests served within a certain time"
    CHECK_RESULT $? 0 0 "Test -d option (disable percentiles table)"
    ab -n 10 -S "$BASE_URL" | grep -v "This is only an estimate"
    CHECK_RESULT $? 0 0 "Test -S option (disable confidence estimators)"
    ab -n 200 -q "$BASE_URL" 2>&1 | grep -v "Completed [0-9]* requests"
    CHECK_RESULT $? 0 0 "Test -q option (disable progress)"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    sudo systemctl stop httpd
    sudo rm -rf "/var/www/html/ab_test"
    rm -rf "$TMP_DIR"
    export LANG="$OLD_LANG"    
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
