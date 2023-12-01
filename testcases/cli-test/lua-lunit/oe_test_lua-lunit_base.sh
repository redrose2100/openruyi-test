#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linian
# @Contact   :   1173417216@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   Test lua-lunit
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lua-lunit"
    cp common/lua lua
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    VER=$(lunit --version | cut -c 9)
    if [ $VER -le 5 ]
    then
        lunit -p "/usr/share/lua/5.2/?.lua;?.lua" | grep 'Loaded'
        CHECK_RESULT $? 0 0 "lunit -p failed"
        lunit --path "/usr/share/lua/5.2/?.lua;?.lua" | grep 'Loaded'
        CHECK_RESULT $? 0 0 "lunit --path failed"
    else
        lunit -p "/usr/share/lua/5.4/?.lua;?.lua" | grep 'Loaded'
        CHECK_RESULT $? 0 0 "lunit -p failed"
        lunit --path "/usr/share/lua/5.4/?.lua;?.lua" | grep 'Loaded'
        CHECK_RESULT $? 0 0 "lunit --path failed"
    fi
    lunit -i lua | grep 'Testsuite finished'
    CHECK_RESULT $? 0 0 "lunit -i failed"
    lunit --interpreter lua | grep 'Testsuite finished'
    CHECK_RESULT $? 0 0 "lunit --interpreter failed"
    lunit --cpath ./?.so | grep 'Loaded'
    CHECK_RESULT $? 0 0 "lunit --cpath failed"
    lunit -r lunit common/test.lua | grep 'hello'
    CHECK_RESULT $? 0 0 "lunit -r failed"
    lunit --runner lunit common/test.lua | grep 'hello'
    CHECK_RESULT $? 0 0 "lunit --runner failed"
    lunit -t common/*.lua | grep 'finished'
    CHECK_RESULT $? 0 0 "lunit -t failed"
    lunit --test common/*.lua | grep 'finished'
    CHECK_RESULT $? 0 0 "lunit--test failed"
    lunit --loadonly common/test.lua | grep 'hello'
    CHECK_RESULT $? 0 0 "lunit --loadonly failed"
    lunit --dontforce common/example.lua | grep '2 passed, 1 failed'
    CHECK_RESULT $? 0 0 "lunit --dontforce failed"
    lunit --help | grep "Usage: lunit"
    CHECK_RESULT $? 0 0 "lunit --help"
    lunit -h | grep "Usage: lunit"
    CHECK_RESULT $? 0 0 "lunit -h failed"
    lunit --version | grep "lunit [[:digit:]]"
    CHECK_RESULT $? 0 0 "lunit --version failed"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f lua
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"