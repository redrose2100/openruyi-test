#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2023/8/27
# @License   :   Mulan PSL v2
# @Desc      :   Test "pyScss" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-scss"
    ver=$(rpm -qi python3-scss | grep -oP 'Version\s+:\s+\K[\d.]+')
    echo "@link-color: #428bca;" > tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    less2scss -h | grep "Usage: less2scss"
    CHECK_RESULT $? 0 0 "Check less2scss -h failed"
    less2scss --help | grep "Usage: less2scss"
    CHECK_RESULT $? 0 0 "Check less2scss --help failed"
    less2scss -v | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check less2scss -v failed"
    less2scss --version | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check less2scss --version failed"
    less2scss tmp
    CHECK_RESULT $? 0 0 "Check less2scss [file] failed"
    echo "\$orig-color: #000000;" > tmp.scss
    CHECK_RESULT $? 0 0
    less2scss tmp -f && grep "\$link-color: #428bca;" tmp.scss
    CHECK_RESULT $? 0 0 "Check less2scss [file] -f failed"
    echo "\$orig-color: #000000;" > tmp.scss
    CHECK_RESULT $? 0 0
    less2scss tmp --force && grep "\$link-color: #428bca;" tmp.scss
    CHECK_RESULT $? 0 0 "Check less2scss [file] --force failed"
    pyscss -h | grep "Usage: pyscss"
    CHECK_RESULT $? 0 0 "Check pyscss -h failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf tmp tmp.scss
    LOG_INFO "End to restore the test environment."
}

main "$@"