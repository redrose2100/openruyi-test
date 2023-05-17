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
        gyp mylib.gyp --depth=./test --no-duplicate-basename-check
        CHECK_RESULT $? 0 0 "Check gyp --no-duplicate-basename-check failed"
        gyp mylib.gyp --depth=./test --no-parallel
        CHECK_RESULT $? 0 0 "Check gyp --no-parallel failed"
        gyp mylib.gyp --depth=./test -Stest && test -f ./test/Makefiletest
        CHECK_RESULT $? 0 0 "Check gyp -S failed"
        gyp mylib.gyp --depth=./test --suffix=testdemo && test -f ./test/Makefiletestdemo
        CHECK_RESULT $? 0 0 "Check gyp --suffix failed"
        gyp mylib.gyp --depth=./test --toplevel-dir=testdemo && test -f ./testdemo/Makefile
        CHECK_RESULT $? 0 0 "Check gyp --toplevel-dir failed"
        gyp mylib.gyp --depth=./test -Rmain
        CHECK_RESULT $? 0 0 "Check gyp -R failed"
        gyp mylib.gyp --depth=./test --root-target=main
        CHECK_RESULT $? 0 0 "Check gyp --root-target failed"
        gyp mylib.gyp --depth=./test --generator-output=outdemo && test -d ./test/outdemo
        CHECK_RESULT $? 0 0 "Check gyp --generator-output failed"
        gyp mylib.gyp --depth=./test --config-dir=./data/common.gypi
        CHECK_RESULT $? 0 0 "Check gyp --config-dir failed"
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
