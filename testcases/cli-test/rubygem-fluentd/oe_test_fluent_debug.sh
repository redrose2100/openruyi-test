#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test fluent-debug
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-debug --help | grep "Usage: fluent-debug"
    CHECK_RESULT $? 0 0 "Check fluent-debug --help failed"
    fluent-debug -h 127.0.0.1 > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep "Connected to druby:" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug -h failed"
    kill -9 $(pgrep -f "fluent-debug -h")
    rm -f tmp.txt
    fluent-debug --host 127.0.0.1 > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep "Connected to druby:" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug --host failed"
    kill -9 $(pgrep -f "fluent-debug --host")
    rm -f tmp.txt
    fluent-debug -h 127.0.0.1 -p 24353 > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep -e "Connected to druby://127.0.0.1:24353" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug -p failed"
    kill -9 $(pgrep -f "fluent-debug -h")
    rm -f tmp.txt
    fluent-debug -h 127.0.0.1 --port 24353 > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep -e "Connected to druby://127.0.0.1:24353" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug --port failed"
    kill -9 $(pgrep -f "fluent-debug -h")
    rm -f tmp.txt
    fluent-debug -h 127.0.0.1  -u tmp.socket > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep -e "Connected to drbunix:tmp.socket" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug -u failed"
    kill -9 $(pgrep -f "fluent-debug -h")
    rm -f tmp.txt
    fluent-debug -h 127.0.0.1  --unix tmp.socket > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep -e "Connected to drbunix:tmp.socket" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-debug --unix failed"
    kill -9 $(pgrep -f "fluent-debug -h")
    rm -f tmp.txt
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
