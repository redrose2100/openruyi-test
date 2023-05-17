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
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-gem rdoc rake | grep "Parsing documentation for rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem rdoc failed"
    fluent-gem search kraken_ruby | grep "kraken_ruby"
    CHECK_RESULT $? 0 0 "Check fluent-gem search failed"
    fluent-gem sources | grep "CURRENT SOURCES"
    CHECK_RESULT $? 0 0 "Check fluent-gem sources failed"
    fluent-gem specification rake | grep "name: rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem specification failed"
    fluent-gem stale | grep "rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem stale failed"
    expect <<-END
    spawn fluent-gem uninstall rake
    expect "in addition to the gem"
    send "y\n"
END
    CHECK_RESULT $? 0 0 "Check fluent-gem uninstall failed"
    fluent-gem unpack rake | grep "Unpacked gem: "
    CHECK_RESULT $? 0 0 "Check fluent-gem unpack failed"
    rm -rf rake-*
    fluent-gem update rake | grep "Updating installed gems"
    CHECK_RESULT $? 0 0 "Check fluent-gem update failed"
    fluent-gem which rake | grep "rake.rb"
    CHECK_RESULT $? 0 0 "Check fluent-gem which failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    expect <<-END
    spawn fluent-gem uninstall rake
    expect "in addition to the gem"
    send "y\n"
END
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
    
main "$@"
