#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/28
# @License   :   Mulan PSL v2
# @Desc      :   Test assimp
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "assimp tar"
    tar -zxvf common/test.tar.gz
    mkdir tmp 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    assimp --help | grep 'assimp <verb> <parameters>'
    CHECK_RESULT $? 0 0 "test assimp help failed"
    version=$(rpm -qa | grep assimp | awk 'BEGIN {FS="-"}{print $2}' | awk '{sub(/..$/,"")}1')
    assimp version | grep $version
    CHECK_RESULT $? 0 0 "test assimp version failed"
    assimp listext | grep '*.3d'
    CHECK_RESULT $? 0 0 "test assimp listext failed"
    assimp info test/1.obj | grep 'Memory consumption: '
    CHECK_RESULT $? 0 0 "test assimp info failed"
    assimp knowext 'obj' | grep 'is known'
    CHECK_RESULT $? 0 0 "test assimp knowext failed"
    assimp listexport | grep '3ds'
    CHECK_RESULT $? 0 0 "test assimp listexport failed"
    assimp export --help | grep 'assimp export'
    CHECK_RESULT $? 0 0 "test assimp export --help failed"
    assimp export ./test/1.obj ./tmp/out -fx && ls ./tmp/out
    CHECK_RESULT $? 0 0 "test assimp export failed"
    assimp extract --help | grep 'assimp extract'
    CHECK_RESULT $? 0 0 "test assimp extract --help failed"
    assimp extract ./test/1.obj -ba | grep 'import took approx'
    CHECK_RESULT $? 0 0 "test assimp extract -ba failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp test/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
