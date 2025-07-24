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
# @Date      :   2025-06-12
# @License   :   Mulan PSL v2
# @Desc      :   command ab
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL httpd
    systemctl start httpd
    TEST_FILE="/var/www/html/test.html"
    echo "Hello, World!" | sudo tee "$TEST_FILE" >/dev/null
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ab -n 10 -c 1 http://localhost/test.html | grep "Requests per second"
    CHECK_RESULT $? 0 0 "Execute basic benchmark test"
    ab -n 100 -c 10 http://localhost/test.html | grep "Concurrency Level"
    CHECK_RESULT $? 0 0 "Test concurrent requests"
    ab -n 10 -T "application/json" -p <(echo '{"key":"value"}') http://localhost/test.html
    CHECK_RESULT $? 0 0 "Test Content-Type option"
    ab -n 100 -c 10 -k http://localhost/test.html | grep "Keep-Alive requests"
    CHECK_RESULT $? 0 0 "Test KeepAlive option"
    ab -n 1 -v 2 http://localhost/test.html | grep -i header
    CHECK_RESULT $? 0 0 "Test verbose output"
    ab -t 5 -c 5 http://localhost/test.html | grep "Time taken for tests"
    CHECK_RESULT $? 0 0 "Test time limit option"
    ab -n 1 http://invalid-host/test.html 2>&1 | grep "Could not resolve host"
    CHECK_RESULT $? 0 1 "Handle invalid host error"
    ab --invalid-option 2>&1 | grep "Invalid option"
    CHECK_RESULT $? 0 1 "Handle invalid option error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop httpd
    rm -f "$TEST_FILE"
    export LANG="$OLD_LANG"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
