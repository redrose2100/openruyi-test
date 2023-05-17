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
# @Desc      :   Test fluentd
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd ruby-devel tar"
    extract_data
    fluent-gem install nokogiri
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluentd -c ./data/fluent.conf -i "inport 18888" -o log.file &
    SLEEP_WAIT 5
    grep "parameter 'inport' in" log.file
    CHECK_RESULT $? 0 0 "Check fluentd -i failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/fluent.conf --inline-config "inport 18888" -o log.file &
    SLEEP_WAIT 5
    grep "parameter 'inport' in" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --inline-config failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/fluent.conf --emit-error-log-interval 2 -d pid.file
    SLEEP_WAIT 5
    ps -ef | grep "fluentd" | grep -e "--emit-error-log-interval"
    CHECK_RESULT $? 0 0 "Check fluentd --emit-error-log-interval failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.file
    fluentd -c ./data/v1_config.conf --conf-encoding utf-8 &
    SLEEP_WAIT 5
    ps -ef | grep "fluentd" | grep -e "--conf-encoding"
    CHECK_RESULT $? 0 0 "Check fluentd --conf-encoding failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.file
    fluentd -c ./data/v1_config.conf --disable-shared-socket &
    SLEEP_WAIT 5
    ps -ef | grep "fluentd" | grep -e "--disable-shared-socket"
    CHECK_RESULT $? 0 0 "Check fluentd --disable-shared-socket failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f pid.file
    fluentd -c ./data/fluentd_cloudwatch_log.conf -p ./lib/gems/fluent-plugin-cloudwatch-logs-0.14.3/lib/fluent/plugin -I ./lib/gems/aws-sdk-cloudwatchlogs-1.53.0/lib -I ./lib/gems/aws-sdk-core-3.155.0/lib/ -I ./lib/gems/aws-partitions-1.637.0/lib/ -I ./lib/gems/jmespath-1.6.1/lib/ -I ./lib/gems/aws-eventstream-1.2.0/lib/ -I ./lib/gems/aws-sigv4-1.5.1/lib/ --suppress-repeated-stacktrace true > tmp.txt 2>&1 &
    SLEEP_WAIT 15
    grep 'suppressed same stacktrace' tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd --suppress-repeated-stacktrace failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/in_forward.conf --without-source -o tmp.log &
    SLEEP_WAIT 5
    grep "'--without-source' is applied. Ignore <source> sections" tmp.log
    CHECK_RESULT $? 0 0 "Check fluentd --without-source failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.log
    fluentd --use-v1-config -c ./data/v1_config.conf -o log.file &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --use-v1-config failed"
    kill -9 $(pgrep -f "fluentd --use-v1-config")
    rm -f log.file
    fluentd --use-v0-config -c ./data/v0_config.conf -o log.file &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --use-v0-config failed"
    kill -9 $(pgrep -f "fluentd --use-v0-config")
    rm -f log.file
    fluentd --strict-config-value -c ./data/strict_value.conf  | grep "config error file"
    CHECK_RESULT $? 0 0 "Check fluentd --strict-config-value failed"
    fluentd --enable-input-metrics -c ./data/in_forward.conf &
    SLEEP_WAIT 5
    ps -ef | grep "fluent" | grep -e  "--enable-input-metrics"
    CHECK_RESULT $? 0 0 "Check fluentd --enable-input-metrics failed"
    kill -9 $(pgrep -f "fluentd --enable-input-metrics")
    fluentd --enable-size-metrics -c ./data/in_forward.conf &
    SLEEP_WAIT 5
    ps -ef | grep "fluent" | grep -e "--enable-size-metrics"
    CHECK_RESULT $? 0 0 "Check fluentd --enable-size-metrics failed"
    kill -9 $(pgrep -f "fluentd --enable-size-metrics")
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
