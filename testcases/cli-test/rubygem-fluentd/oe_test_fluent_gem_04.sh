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
# @Date      :   2023/06/15
# @License   :   Mulan PSL v2
# @Desc      :   Test fluent-gem
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$OET_PATH/testcases/cli-test/rubygem-fluentd/common/lib/util.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-gem signin -h | grep "Usage: gem signin"
    CHECK_RESULT $? 0 0 "Check fluent-gem signin -h failed"
    fluent-gem signin --help | grep "Usage: gem signin"
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --help failed"
    expect <<-END
    spawn fluent-gem signin -V
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin -V failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin --no-verbose
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --no-verbose failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin --quiet
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --quiet failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin -q
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin -q failed"
    fluent-gem signin --silent
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --silent failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin --config-file ./common/credentials --otp rubytest1031
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --config-file and --opt failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin --backtrace
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --backtrace failed"
    fluent-gem signin --debug 2>&1 | grep "Debugging mode prints"
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --debug failed"
    fluent-gem signout
    expect <<-END
    spawn fluent-gem signin --norc --host https://rubygems.org
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
    CHECK_RESULT $? 0 0 "Check fluent-gem signin --norc and --host failed"
    fluent-gem signout
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
