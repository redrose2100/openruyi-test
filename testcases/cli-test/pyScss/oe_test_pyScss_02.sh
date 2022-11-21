#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/9/12
# @License   :   Mulan PSL v2
# @Desc      :   Test "pyScss" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    pip3 install pyScss
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    python -mscss --suffix STRING &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --suffix failed"
    python -mscss --time &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --time failed"
    python -mscss --debug-info &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --debug-info failed"
    python -mscss --no-debug-info &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --no-debug-info failed"
    python -mscss -t NAME &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -t failed"
    python -mscss --style NAME &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --style failed"
    python -mscss -C &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -C failed"
    python -mscss --no-compress &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --no-compress failed"
    python -mscss -h | grep "Converts Scss files to CSS."
    CHECK_RESULT $? 0 0 "Check pyScss -h failed"
    python -mscss --help | grep "Converts Scss files to CSS."
    CHECK_RESULT $? 0 0 "Check pyScss --help failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    pip3 uninstall -y pyScss
    LOG_INFO "End to restore the test environment."
}

main "$@"