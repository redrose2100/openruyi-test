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
# @Date      :   2025-06-23
# @License   :   Mulan PSL v2
# @Desc      :   command ab02
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL httpd
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
    ab -s 5 "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -s option (timeout)"
    ab -b 8192 "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -b option (TCP buffer size)"
    ab -B 127.0.0.1 "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -B option (bind address)"
    ab -p "$POST_DATA" -T "application/x-www-form-urlencoded" "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -p option (POST data)"
    ab -u "$POST_DATA" -T "application/x-www-form-urlencoded" "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -u option (PUT data)"
    ab -n 1 -v 2 "$BASE_URL" | grep header
    CHECK_RESULT $? 0 0 "Test -v option (verbosity)"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    sudo systemctl stop httpd
    sudo rm -rf "/var/www/html/ab_test"
    rm -rf "$TMP_DIR"
    export LANG="$OLD_LANG"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
