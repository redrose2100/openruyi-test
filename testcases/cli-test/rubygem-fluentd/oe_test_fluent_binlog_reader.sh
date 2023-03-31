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
# @Desc      :   Test fluent-binlog-reader
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
    fluent-binlog-reader --help | grep "Usage: fluent-binlog-reader"
    CHECK_RESULT $? 0 0 "Check fluent-binlog-reader --help failed"
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    fluent-binlog-reader cat log.info | grep -e "log.info.*null"
    CHECK_RESULT $? 0 0 "Check fluent-binlog-reader cat failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluentd -c ./data/in_forward_cat.conf -d pid.info -o log.info
    SLEEP_WAIT 5
    fluent-binlog-reader head log.info | grep -e "log.info.*null"
    CHECK_RESULT $? 0 0 "Check fluent-binlog-reader head failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.info pid.info
    fluent-binlog-reader formats | grep "stdout"
    CHECK_RESULT $? 0 0 "Check fluent-binlog-reader formats failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
