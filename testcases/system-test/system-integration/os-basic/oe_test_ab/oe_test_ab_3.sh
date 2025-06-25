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
# @Date      :   2025-06-24
# @License   :   Mulan PSL v2
# @Desc      :   command ab03
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
    ab -n 1 -w "$BASE_URL" | grep "<table"
    CHECK_RESULT $? 0 0 "Test -w option (HTML output)"
    ab -n 1 -i "$BASE_URL" | grep "Document Length:" | grep "0 bytes"
    CHECK_RESULT $? 0 0 "Test -i option (HEAD request)"
    ab -n 1 -w -x "class='test'" "$BASE_URL" | grep "class='test'"
    CHECK_RESULT $? 0 0 "Test -x option (table attributes)"
    ab -n 1 -w -y "style='color:red'" "$BASE_URL" | grep "style='color:red'"
    CHECK_RESULT $? 0 0 "Test -y option (tr attributes)"
    ab -n 1 -w -z "align='center'" "$BASE_URL" | grep "align='center'"
    CHECK_RESULT $? 0 0 "Test -z option (td/th attributes)"
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
