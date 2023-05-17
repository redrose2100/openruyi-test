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
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test gyp
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gyp tar"
    tar -xvf common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gyp --help | grep "Usage: gyp"
    CHECK_RESULT $? 0 0 "Check gyp --help failed"
    pushd gypdemo
        gyp mylib.gyp --depth=./test && test -d ./test
        CHECK_RESULT $? 0 0 "Check gyp --depth failed"
        gyp mylib.gyp --depth=./test --format=make
        CHECK_RESULT $? 0 0 "Check gyp --format failed"
        gyp mylib.gyp --depth=./test -fmake
        CHECK_RESULT $? 0 0 "Check gyp -f failed"
        gyp mylib.gyp --depth=./test -dall | grep "mylib.gyp"
        CHECK_RESULT $? 0 0 "Check gyp -d failed"
        gyp mylib.gyp --depth=./test --debug=all | grep "mylib.gyp"
        CHECK_RESULT $? 0 0 "Check gyp --debug failed"
        gyp mylib.gyp --depth=./test -D test=test
        CHECK_RESULT $? 0 0 "Check gyp -D failed"
        gyp mylib.gyp --depth=./test --ignore-environment
        CHECK_RESULT $? 0 0 "Check gyp --ignore-environment failed"
        gyp mylib.gyp --depth=./test --include=./data/common.gypi
        CHECK_RESULT $? 0 0 "Check gyp --include failed"
        gyp mylib.gyp --depth=./test -I./data/common.gypi
        CHECK_RESULT $? 0 0 "Check gyp -I failed"
        gyp mylib.gyp --depth=./test --no-circular-check
        CHECK_RESULT $? 0 0 "Check gyp --no-circular-check failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./gypdemo
    LOG_INFO "End to restore the test environment."
}

main "$@"
