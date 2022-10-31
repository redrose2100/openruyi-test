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
# @Desc      :   Test fluent-ca-generate
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
    fluent-ca-generate -h | grep "Usage: fluent-ca-generate DIR_PATH"
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate -h failed"
    fluent-ca-generate tmp tmp@123 --key-length 1024
    test -f ./tmp/ca_key.pem 
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate --key-length failed"
    rm -rf tmp
    fluent-ca-generate tmp tmp@123 --country UA
    test -f ./tmp/ca_key.pem
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate --country failed"
    rm -rf tmp
    fluent-ca-generate tmp tmp@123 --state CA
    test -f ./tmp/ca_key.pem
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate --state failed"
    rm -rf tmp
    fluent-ca-generate tmp tmp@123 --locality local
    test -f ./tmp/ca_key.pem
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate --locality failed"
    rm -rf tmp
    fluent-ca-generate tmp tmp@123 --common-name catmp
    test -f ./tmp/ca_key.pem
    CHECK_RESULT $? 0 0 "Check fluent-ca-generate --common-name failed"
    rm -rf tmp
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
