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
# @Date      :   2023/3/1
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
    assimp extract ./test/1.obj -t1 | grep 'assimp extract: Texture'
    CHECK_RESULT $? 0 0 "test assimp extract -t failed"
    assimp extract ./test/1.obj -f | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "test assimp extract -f failed"
    assimp extract ./test/1.obj -cfast | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "test assimp extract -cfast failed"
    assimp extract ./test/1.obj -cdefault | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "test assimp extract -cdefault failed"
    assimp extract ./test/1.obj -cfull | grep 'Exporting [0-9]* textures'
    CHECK_RESULT $? 0 0 "test assimp extract -cfull failed"
    assimp exportinfo obj | grep 'obj'
    CHECK_RESULT $? 0 0 "test assimp exportinfo failed"
    assimp dump ./test/1.obj ./tmp/1.xml && ls ./tmp/1.xml
    CHECK_RESULT $? 0 0 "test assimp dump failed"
    cp -r ./tmp/1.xml ./tmp/2.xml && assimp cmpdump ./tmp/1.xml ./tmp/2.xml | grep 'Success'
    CHECK_RESULT $? 0 0 "test assimp cmpdump failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp test/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
