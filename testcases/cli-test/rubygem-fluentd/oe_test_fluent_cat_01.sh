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
# @Desc      :   Test fluent-cat
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
    fluent-cat --help | grep "Usage: fluent-cat" 
    CHECK_RESULT $? 0 0 "Check fluent-cat --help failed"
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -h 127.0.0.1 -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat -p failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -h 127.0.0.1 --port 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --port failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -h 0.0.0.0 -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat -h failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log --host 0.0.0.0 -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --host failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_unix.conf -o log.info -d pid.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -u -s /tmp/socket.sock
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat -u failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info /tmp/socket.sock
    fluentd -c ./data/in_unix.conf -o log.info -d pid.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log --unix -s /tmp/socket.sock
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --unix failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info /tmp/socket.sock
    fluentd -c ./data/in_unix.conf -o log.info -d pid.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -u -s /tmp/socket.sock
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat -s failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info /tmp/socket.sock
    fluentd -c ./data/in_unix.conf -o log.info -d pid.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -u --socket /tmp/socket.sock
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --socket failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info /tmp/socket.sock
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
