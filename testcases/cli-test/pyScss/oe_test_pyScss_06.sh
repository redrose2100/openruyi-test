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
    echo '$orig-color: #000000;' > tmp.scss
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    pyscss -h | grep "Usage: pyscss"
    CHECK_RESULT $? 0 0 "Check pyscss -h failed"
    pyscss --help | grep "Usage: pyscss"
    CHECK_RESULT $? 0 0 "Check pyscss --help failed"
    pyscss -v | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check pyscss -v failed"
    pyscss --version | grep "pyScss v$ver"
    CHECK_RESULT $? 0 0 "Check pyscss --version failed"
    pyscss tmp.scss | grep ^$
    CHECK_RESULT $? 0 0 "Check pyscss [file] failed"

    
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    
    LOG_INFO "End to restore the test environment."
}

main "$@"