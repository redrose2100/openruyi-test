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
# @Date      :   2025-7-21
# @License   :   Mulan PSL v2
# @Desc      :   command ab05
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl start httpd
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    TMP_DIR=$(mktemp -d)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    BASE_URL="http://localhost/ab_test/test.html"
    ab -n 2 -l "http://localhost/ab_test/dynamic.php"
    CHECK_RESULT $? 0 0 "Test -l option (variable document length)"
    
    OUTPUT_GNU="$TMP_DIR/results.gnu"
    ab -n 10 -g "$OUTPUT_GNU" "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -g option (gnuplot output)"
    grep "time" "$OUTPUT_GNU"
    CHECK_RESULT $? 0 0 "Verify gnuplot output format"
    
    OUTPUT_CSV="$TMP_DIR/results.csv"
    ab -n 10 -e "$OUTPUT_CSV" "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -e option (CSV output)"
    grep "Percentage" "$OUTPUT_CSV"
    CHECK_RESULT $? 0 0 "Verify CSV output format"

    ab -n 10 -r "$BASE_URL"
    CHECK_RESULT $? 0 0 "Test -r option (ignore socket errors)"
    ab -n 1 -m OPTIONS "$BASE_URL" | grep Apache
    CHECK_RESULT $? 0 0 "Test -m option (HTTP method)"
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
