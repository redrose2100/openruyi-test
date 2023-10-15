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
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log -f json -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat -f failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log --format json -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --format failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo '{"message":"hello"}' | fluent-cat debug.log --json -p 24454
    grep 'no patterns matched tag="debug.log"' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --json failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat_tag.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo "aaaaaaaaa" | fluent-cat debug.log --none -p 24454
    grep -e 'debug.log: {"message":"aaaaaaaaa"}' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --none failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat_tag.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo "aaaaaaaaa" | fluent-cat debug.log --none -p 24454 --message-key message1
    grep -e 'debug.log: {"message1":"aaaaaaaaa"}' log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --message-key failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat_tag.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo "aaaaaaaaa" | fluent-cat debug.log --none -p 24454 --time-as-integer 
    grep "000000000" log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --time-as-integer failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    echo "aaaaaaaaa" | fluent-cat debug.log --none -p 24494 --retry-limit 2 > tmp.txt 2>&1
    retrytime=$(grep "Connection refused" tmp.txt | wc -l)
    test ${retrytime} -eq 3
    CHECK_RESULT $? 0 0 "Check fluent-cat --retry-limit failed"
    rm -f tmp.txt
    fluentd -c ./data/in_forward_cat_tag.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo "aaaaaaaaa" | fluent-cat debug.log --none -p 24454 --event-time "2021-10-29 13:14:15.0+00:00"
    grep "2021-10-29 21:14:15.000000000" log.info
    CHECK_RESULT $? 0 0 "Check fluent-cat --event-time failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat_tag.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    echo "source"=>"source_val" | fluent-cat debug.log --msgpack -p 24454
    grep "source=" source_val
    CHECK_RESULT $? 0 0 "Check fluent-cat --msgpack failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info source_val
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
