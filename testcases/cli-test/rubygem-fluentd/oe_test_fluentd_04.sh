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
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    useradd demo
    chown -R demo:demo ./data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluentd -c ./data/in_forward.conf -v -o log.file &
    SLEEP_WAIT 5
    grep "debug" log.file
    CHECK_RESULT $? 0 0 "Check fluentd -v failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/in_forward.conf --verbose -o log.file &
    SLEEP_WAIT 5
    grep "debug" log.file
    CHECK_RESULT $? 0 0 "Check fluentd --verbose failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/in_forward.conf -q -o log.file &
    SLEEP_WAIT 5
    grep "info" log.file
    CHECK_RESULT $? 1 0 "Check fluentd -q failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/in_forward.conf --quiet -o log.file &
    SLEEP_WAIT 5
    grep "info" log.file
    CHECK_RESULT $? 1 0 "Check fluentd --quiet failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    fluentd -c ./data/v1_config.conf --suppress-config-dump -o log.file &
    SLEEP_WAIT 5
    grep "type monitor_agent" log.file
    CHECK_RESULT $? 1 0 "Check fluentd --suppress-config-dump failed"
    kill -9 $(pgrep -f "fluentd -c")
    rm -f log.file
    su demo -c "fluentd --gemfile ./data/Gemfile &"
    SLEEP_WAIT 30
    ls -al ./data | grep "vendor"
    CHECK_RESULT $? 0 0 "Check fluentd --gemfile failed"
    kill -9 $(pgrep -f "fluentd --gemfile")
    rm -rf ./data/vendor Gemfile.lock
    exit
    su demo -c "fluentd -g ./data/Gemfile &"
    SLEEP_WAIT 30
    ls -al ./data | grep "vendor"
    CHECK_RESULT $? 0 0 "Check fluentd -g failed"
    kill -9 $(pgrep -f "fluentd -g")
    rm -rf ./data/vendor Gemfile.lock
    exit
    su demo -c "fluentd -g ./data/Gemfile --gem-path installpath &"
    SLEEP_WAIT 30
    ls -al ./data | grep "installpath"
    CHECK_RESULT $? 0 0 "Check fluentd --gem-path failed"
    kill -9 $(pgrep -f "fluentd -g")
    rm -rf ./data/installpath Gemfile.lock
    exit
    su demo -c "fluentd -g ./data/Gemfile -G installpath &"
    SLEEP_WAIT 30
    ls -al ./data | grep "installpath"
    CHECK_RESULT $? 0 0 "Check fluentd -G failed"
    kill -9 $(pgrep -f "fluentd -g")
    rm -rf ./data/installpath Gemfile.lock
    exit
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    userdel -r demo
    chown -R root:root ./data
    LOG_INFO "End to restore the test environment."
}
main "$@"
