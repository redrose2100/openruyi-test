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
# @Desc      :   Test fluent-plugin-generate
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    gem update --system
    gem install test-unit
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-plugin-generate -h | grep "Usage: fluent-plugin-generate"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-generate -h failed"
    mkdir ./tmp1
    pushd tmp1
        fluent-plugin-generate input http2
        ls -al | grep fluent-plugin-http2
        CHECK_RESULT $? 0 0 "Check fluent-plugin-generate failed"
    popd
    mkdir ./tmp2
    pushd tmp2
        fluent-plugin-generate --license="no-license" input http2
        ls -al ./fluent-plugin-http2 | grep "LICENSE"
        CHECK_RESULT $? 1 0 "Check fluent-plugin-generate --license failed"
    popd
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./tmp1 ./tmp2
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
