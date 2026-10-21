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
# @Desc      :   Test fluent-cap-ctl
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$OET_PATH/testcases/function-test/pkgs-test/rubygem-fluentd/common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar ruby-devel rubygems-devel libcap-ng-devel wget"
    wget https://rubygems.org/gems/capng_c-0.2.2.gem
    gem install capng_c-0.2.2.gem
    gem install did_you_mean
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-cap-ctl --help | grep "Usage: fluent-cap-ctl"
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --help failed"
    fluent-cap-ctl --add dac_read_search | grep "Adding dac_read_search done"
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --add failed"
    fluent-cap-ctl --drop dac_read_search | grep "Dropping dac_read_search done."
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --drop failed"
    fluent-cap-ctl --add dac_read_search
    fluent-cap-ctl --clear | grep "Clear capabilities done."
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --clear failed"
    fluent-cap-ctl --get | grep "Effective:"
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --get failed"
    echo "aa" > test.file
    fluent-cap-ctl --file test.file
    CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --file failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf capng_c-0.2.2.gem test.file
    gem uninstall did_you_mean capng_c
    LOG_INFO "End to restore the test environment."
}
main "$@"
