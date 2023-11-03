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
source "$OET_PATH/testcases/cli-test/rubygem-fluentd/common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    fluent-gem install rake
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
    fluent-gem unpack rake | grep "Unpacked gem: "
    CHECK_RESULT $? 0 0 "Check fluent-gem unpack failed"
    rm -rf rake-*
    fluent-gem update rake | grep "Updating installed gems"
    CHECK_RESULT $? 0 0 "Check fluent-gem update failed"
    fluent-gem which rake | grep "rake.rb"
    CHECK_RESULT $? 0 0 "Check fluent-gem which failed"
    expect <<-END
    spawn fluent-gem signin
    expect "Email:"
    send "349464272@qq.com\n"
    expect "Password:"
    sleep 1
    send "rubytest1031\n"
    expect "API Key name"
    send "yy\n"
    expect "index_rubygems"
    send "y\n"
    expect "push_rubygem"
    send "n\n"
    expect "yank_rubygem"
    send "n\n"
    expect "add_owner"
    send "n\n"
    expect "remove_owner"
    send "n\n"
    expect "access_webhooks"
    send "n\n"
    expect "show_dashboard"
    send "n\n"
    expect eof
END
    CHECK_RESULT $? 0 0 "Check fluent-gem signin failed"
    expect <<-END
    spawn fluent-gem uninstall rake
    sleep 1
    expect {
        "to the gem" {
            send "y\n"
            exp_continue
        }
        timeout {
            puts "Timeout error: could not find \"to the gem\" in output"
            exit 0
        }
    }
END
    CHECK_RESULT $? 0 0 "Check fluent-gem uninstall failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    fluent-gem signout
    DNF_REMOVE "$@"
    clean_dir
    LOG_INFO "End to restore the test environment."
}
    
main "$@"
