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
# @Desc      :   Test fluent-ctl
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
    fluent-ctl -h | grep "COMMAND PID"
    CHECK_RESULT $? 0 0 "Check fluent-ctl -h failed"
    fluentd -c ./data/v1_config.conf -d pid.info
    SLEEP_WAIT 2
    pidnum=$(cat pid.info)
    fluent-ctl shutdown ${pidnum}
    SLEEP_WAIT 2
    ps -ef | grep "fluentd -c" | grep -v "grep"
    CHECK_RESULT $? 1 0 "Check fluent-ctl shutdown failed"
    rm -f pid.info
    fluentd -c ./data/v1_config.conf -d pid.info -o log.file
    SLEEP_WAIT 2
    pidnum=$(cat pid.info)
    fluent-ctl restart ${pidnum}
    SLEEP_WAIT 3
    grep "Worker 0 finished unexpectedly with status 0" log.file
    CHECK_RESULT $? 0 0 "Check fluent-ctl restart failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.info log.file
    fluentd -c ./data/v1_config.conf -d pid.info -o log.file
    SLEEP_WAIT 20
    pidnum=$(cat pid.info)
    fluent-ctl flush ${pidnum}
    SLEEP_WAIT 20
    grep "force flushing buffered events" log.file
    CHECK_RESULT $? 0 0 "Check fluent-ctl flush failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.info log.file
    fluentd -c ./data/v1_config.conf -d pid.info -o log.file
    SLEEP_WAIT 2
    pidnum=$(cat pid.info)
    fluent-ctl reload ${pidnum}
    SLEEP_WAIT 3
    grep "restart fluentd worker worker" log.file
    CHECK_RESULT $? 0 0 "Check fluent-ctl reload failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.info log.file
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
