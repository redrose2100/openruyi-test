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
    fluentd -h | grep "Usage: fluentd"
    CHECK_RESULT $? 0 0 "Check fluentd -h failed"
    fluentd --help | grep "Usage: fluentd"
    CHECK_RESULT $? 0 0 "Check fluentd --help failed"
    fluentd --version | grep "fluentd [0-9]."
    CHECK_RESULT $? 0 0 "Check fluentd --version failed"
    if [[ -d /etc/fluent ]]; then
        rm -rf /etc/fluent
    fi
    fluentd --setup /etc/fluent
    grep "Label: For handling complex event routing" /etc/fluent/fluent.conf
    CHECK_RESULT $? 0 0 "Check fluentd --setup failed"
    if [[ -d /etc/fluent ]]; then
        rm -rf /etc/fluent
    fi
    fluentd -s /etc/fluent
    grep "Label: For handling complex event routing" /etc/fluent/fluent.conf
    CHECK_RESULT $? 0 0 "Check fluentd -s failed"
    fluentd -c ./data/fluent.conf > tmp.txt &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker=0" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd -c failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd --config ./data/fluent.conf > tmp.txt &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker=0" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd --config failed"
    kill -9 $(pgrep -f "fluentd --config")
    rm -f tmp.txt
    fluentd -c ./data/fluent.conf --dry-run | grep -e "\[info]: finished dry run mode"
    CHECK_RESULT $? 0 0 "Check fluentd --dry-run failed"
    fluentd --show-plugin-config=input | grep "show_plugin_config option is deprecated. Use fluent-plugin-config-format"
    CHECK_RESULT $? 0 0 "Check fluentd --show-plugin-config failed"
    fluentd -c ./data/fluentd_cloudwatch_log.conf -p ./lib/gems/fluent-plugin-cloudwatch-logs-0.14.3/lib/fluent/plugin -I ./lib/gems/aws-sdk-cloudwatchlogs-1.53.0/lib -I ./lib/gems/aws-sdk-core-3.155.0/lib/ -I ./lib/gems/aws-partitions-1.637.0/lib/ -I ./lib/gems/jmespath-1.6.1/lib/ -I ./lib/gems/aws-eventstream-1.2.0/lib/ -I ./lib/gems/aws-sigv4-1.5.1/lib/ > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep 'adding match pattern="test.cloudwatch_logs.out"' tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd -p failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/fluentd_cloudwatch_log.conf --plugin ./lib/gems/fluent-plugin-cloudwatch-logs-0.14.3/lib/fluent/plugin -I ./lib/gems/aws-sdk-cloudwatchlogs-1.53.0/lib -I ./lib/gems/aws-sdk-core-3.155.0/lib/ -I ./lib/gems/aws-partitions-1.637.0/lib/ -I ./lib/gems/jmespath-1.6.1/lib/ -I ./lib/gems/aws-eventstream-1.2.0/lib/ -I ./lib/gems/aws-sigv4-1.5.1/lib/ > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep 'adding match pattern="test.cloudwatch_logs.out"' tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd --plugin failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/fluentd_cloudwatch_log.conf -p ./lib/gems/fluent-plugin-cloudwatch-logs-0.14.3/lib/fluent/plugin -I ./lib/gems/aws-sdk-cloudwatchlogs-1.53.0/lib -I ./lib/gems/aws-sdk-core-3.155.0/lib/ -I ./lib/gems/aws-partitions-1.637.0/lib/ -I ./lib/gems/jmespath-1.6.1/lib/ -I ./lib/gems/aws-eventstream-1.2.0/lib/ -I ./lib/gems/aws-sigv4-1.5.1/lib/ > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep 'adding match pattern="test.cloudwatch_logs.out"' tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd -I failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f tmp.txt
    fluentd -c ./data/fluent.conf -I ./lib/gems/http_parser.rb-0.8.0/lib/ -r http_parser > tmp.txt 2>&1 &
    SLEEP_WAIT 5
    grep "fluentd worker is now running worker=0" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluentd -c failed"
    kill -9 $(pgrep -f "fluentd -c")
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
