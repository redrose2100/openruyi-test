#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test Anthy
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL anthy
    tar -zxvf ./test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    anthy-agent --version | grep 'anthy-agent'
    CHECK_RESULT $? 0 0 "Failed option: anthy-agent --version"
    anthy-dic-tool --version | grep 'Anthy-dic-util'
    CHECK_RESULT $? 0 0 "Failed option: anthy-dic-tool --version"
    anthy-dic-tool --help | grep 'Anthy-dic-util'
    CHECK_RESULT $? 0 0 "Failed option: anthy-dic-tool --help"
    anthy-morphological-analyzer < test/a.txt | grep 'segments:'
    CHECK_RESULT $? 0 0 "Failed option: anthy-morphological-analyzer"
    anthy-dic-tool --dump | grep '#anthy 9100h'
    CHECK_RESULT $? 0 0 "Failed option: anthy-dic-tool --dump"
    anthy-dic-tool --dump 2>&1 | anthy-dic-tool --load && echo $? | grep '0' 
    CHECK_RESULT $? 0 0 "Failed option: anthy-dic-tool --load"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
