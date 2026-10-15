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
    echo "\$bg-color: #FFF;.container {background-color: \$bg-color;}" > tmp.scss
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    pyscss --help | grep "Usage: pyscss"
    CHECK_RESULT $? 0 0 "Check pyscss --help failed"
    pyscss tmp.scss | grep '.container{background-color:#fff}'
    CHECK_RESULT $? 0 0 "Check pyscss [file] failed"
    (pyscss -i & echo exit) | grep 'Bye!'
    CHECK_RESULT $? 0 0 "Check pyscss -i failed"
    (pyscss --interactive & echo exit) | grep 'Bye!'
    CHECK_RESULT $? 0 0 "Check pyscss --interactive failed"
    pyscss tmp.scss -r
    CHECK_RESULT $? 0 0 "Check pyscss -r failed"
    pyscss tmp.scss --recursive
    CHECK_RESULT $? 0 0 "Check pyscss --recursive failed"
    pyscss tmp.scss -o tmp.css && grep '.container{background-color:#fff}' tmp.css
    CHECK_RESULT $? 0 0 "Check pyscss -o failed"
    pyscss tmp.scss --output tmp.css && grep '.container{background-color:#fff}' tmp.css
    CHECK_RESULT $? 0 0 "Check pyscss --output failed"
    pyscss tmp.scss -s STRING
    CHECK_RESULT $? 0 0 "Check pyscss -s failed"
    pyscss tmp.scss --suffix STRING
    CHECK_RESULT $? 0 0 "Check pyscss --suffix failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf tmp.scss tmp.css
    LOG_INFO "End to restore the test environment."
}

main "$@"