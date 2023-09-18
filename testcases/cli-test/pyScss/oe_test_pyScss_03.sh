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
    echo "\$bg-color: #FFF;.container {background-color: \$bg-color;}" > tmp.scss
    mkdir dir
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    pyscss tmp.scss --time
    CHECK_RESULT $? 0 0 "Check pyscss --time failed"
    pyscss tmp.scss --debug-info
    CHECK_RESULT $? 0 0 "Check pyscss --debug-info failed"
    pyscss tmp.scss --no-debug-info
    CHECK_RESULT $? 0 0 "Check pyscss --no-debug-info failed"
    pyscss tmp.scss -t NAME | grep '.container {'
    CHECK_RESULT $? 0 0 "Check pyscss -t failed"
    pyscss tmp.scss --style NAME | grep '.container {'
    CHECK_RESULT $? 0 0 "Check pyscss --style failed"
    pyscss tmp.scss -C | grep '.container {'
    CHECK_RESULT $? 0 0 "Check pyscss -C failed"
    pyscss tmp.scss --no-compress | grep '.container {'
    CHECK_RESULT $? 0 0 "Check pyscss --no-compress failed"
    pyscss -v | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check pyscss -v failed"
    pyscss --version | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check pyscss --version failed"
    pyscss tmp.scss --sass
    CHECK_RESULT $? 0 0 "Check pyscss --sass failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf tmp.scss tmp.css dir
    LOG_INFO "End to restore the test environment."
}

main "$@"