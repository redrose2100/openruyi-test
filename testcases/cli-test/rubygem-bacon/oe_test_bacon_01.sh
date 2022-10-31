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
# @Desc      :   Test bacon
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-bacon tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test -h
    bacon -h | grep "Usage: bacon"
    CHECK_RESULT $? 0 0 "Check bacon -h failed"
    # test --help
    bacon --help | grep "Usage: bacon"
    CHECK_RESULT $? 0 0 "Check bacon --help failed"
    # test --version
    bacon --version | grep "[0-9].[0-9]"
    CHECK_RESULT $? 0 0 "Check bacon --version failed"
    # test -s
    bacon -s ./data/whirlwind.rb | grep "6 specifications (8 requirements), 2 failures"
    CHECK_RESULT $? 0 0 "Check bacon -s failed"
    # test --specdox
    bacon --specdox ./data/whirlwind.rb | grep "6 specifications (8 requirements), 2 failures"
    CHECK_RESULT $? 0 0 "Check bacon --specdox failed"
    # test -q
    bacon -q ./data/whirlwind.rb | grep "..F..F"
    CHECK_RESULT $? 0 0 "Check bacon -q failed"
    # test --quiet
    bacon --quiet ./data/whirlwind.rb | grep "..F..F"
    CHECK_RESULT $? 0 0 "Check bacon --quite failed"
    # test -p
    bacon -p ./data/whirlwind.rb | grep "ok 1   - should be empty"
    CHECK_RESULT $? 0 0 "Check bacon -p failed"
    # test --tap
    bacon --tap ./data/whirlwind.rb | grep "ok 1   - should be empty"
    CHECK_RESULT $? 0 0 "Check bacon --tap failed"
    # test -k
    bacon -k ./data/whirlwind.rb | grep "not ok - should raise on trying fetch any index"
    CHECK_RESULT $? 0 0 "Check bacon -k failed"
    # test --knock
    bacon --knock ./data/whirlwind.rb | grep "not ok - should raise on trying fetch any index"
    CHECK_RESULT $? 0 0 "Check bacon --knock failed"
    # test -o
    bacon -o TestUnit ./data/whirlwind.rb | grep "..F..F"
    CHECK_RESULT $? 0 0 "Check bacon -o failed"
    # test --output
    bacon --output TestUnit ./data/whirlwind.rb | grep "..F..F"
    CHECK_RESULT $? 0 0 "Check bacon --output failed"
    # test -Q
    bacon -Q ./data/whirlwind.rb | grep -e "- should have super powers \[FAILED]"
    CHECK_RESULT $? 0 0 "Check bacon -Q failed"
    # test --no-backtrace
    bacon --no-backtrace ./data/whirlwind.rb | grep -e "- should have super powers \[FAILED]"
    CHECK_RESULT $? 0 0 "Check bacon --no-backtrace failed"
    # test -a
    bacon -a | grep "88 specifications (800 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon -a failed"
    # test --automatic
    bacon --automatic | grep "88 specifications (800 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon --automatic failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data ./lib/ ./test/
    LOG_INFO "End to restore the test environment."
}
main "$@"
