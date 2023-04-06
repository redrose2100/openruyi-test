#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test Anthy
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "anthy"
    echo 'hello' > a.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    version=$(rpm -qa | grep anthy | awk 'BEGIN {FS="-"}{print $2}' | tail -n 1)
    anthy-agent --version | grep $version
    CHECK_RESULT $? 0 0 "test anthy-agent --version failed"
    anthy-dic-tool --version | grep $version
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --version failed"
    anthy-dic-tool --help | grep 'Anthy-dic-util'
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --help failed"
    anthy-morphological-analyzer < a.txt | grep 'segments:'
    CHECK_RESULT $? 0 0 "test anthy-morphological-analyzer failed"
    anthy-dic-tool --dump | grep '#anthy'
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --dump failed"
    anthy-dic-tool --dump 2>&1 | anthy-dic-tool --load
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --load failed"
    cat a.txt |  anthy-dic-tool --append
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --append failed"
    anthy-dic-tool --dump --utf8 | grep 'anthy'
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --utf8 failed"
    anthy-dic-tool --dump --personality=Anthy
    CHECK_RESULT $? 0 0 "test anthy-dic-tool --personality failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf a.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
