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
    mkdir dir
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    pyscss tmp.scss -I dir
    CHECK_RESULT $? 0 0 "Check pyscss -I failed"
    pyscss tmp.scss --load-path dir
    CHECK_RESULT $? 0 0 "Check pyscss --load-path failed"
    pyscss tmp.scss -S dir
    CHECK_RESULT $? 0 0 "Check pyscss -S failed"
    pyscss tmp.scss --static-root dir
    CHECK_RESULT $? 0 0 "Check pyscss --static-root failed"
    pyscss tmp.scss -A dir
    CHECK_RESULT $? 0 0 "Check pyscss -A failed"
    pyscss tmp.scss --assets-root dir
    CHECK_RESULT $? 0 0 "Check pyscss --assets-root failed"
    pyscss tmp.scss -a URL
    CHECK_RESULT $? 0 0 "Check pyscss -A failed"
    pyscss tmp.scss --assets-url URL
    CHECK_RESULT $? 0 0 "Check pyscss --assets-url failed"
    pyscss tmp.scss -F PATH
    CHECK_RESULT $? 0 0 "Check pyscss -F failed"
    pyscss tmp.scss --fonts-root PATH
    CHECK_RESULT $? 0 0 "Check pyscss --fonts-root failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf tmp.scss tmp.css dir
    LOG_INFO "End to restore the test environment."
}

main "$@"