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
# @Desc      :   Test fluent-gem
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    fluent-gem install rake
    fluent-gem install rubygems-mirror
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    rakevershon=$(fluent-gem list rake | grep "rake" | awk -F "(" '{print $2}' | awk -F ")" '{print $1}')
    fluent-gem lock rake-13.0.6 | grep "gem 'rake'"
    CHECK_RESULT $? 0 0 "Check fluent-gem lock failed"
    cp ./data/.mirrorrc ~/.gem/.mirrorrc
    mkdir -p /tmp/testdata
    fluent-gem mirror > tmp.txt 2>&1 &
    SLEEP_WAIT 60
    grep "Total gems" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-gem mirror failed"
    kill -9 $(pgrep -f "fluent-gem mirror")
    rm -rf tmp.txt /tmp/testdata ~/.gem/.mirrorrc
    fluent-gem open -e cat rake > tmp.txt 2>&1
    grep "cat:" tmp.txt
    CHECK_RESULT $? 0 0 "Check fluent-gem open failed"
    rm -f tmp.txt
    fluent-gem outdated
    CHECK_RESULT $? 0 0 "Check fluent-gem outdated failed"
    fluent-gem pristine rake | grep "Restored rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem pristine failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
    
main "$@"
