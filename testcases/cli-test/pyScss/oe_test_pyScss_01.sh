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
    echo -e "p {\n  // currentColor is not actually a SCSS color value, but should be left alone\n  background-image: linear-gradient(to top, transparent, currentColor);\n}" > current-color.scss
    mkdir tmp_dir
    pip3 install pyScss
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    python -mscss < current-color.scss | grep "currentColor"
    CHECK_RESULT $? 0 0 "Check pyScss -m failed"
    expect<<EOF
    spawn python -mscss -i
    expect "Welcome to pyScss v1.4.0" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check pyScss -i failed"
    expect<<EOF
    spawn python -mscss --interactive
    expect "Welcome to pyScss v1.4.0" {send "exit\n"}
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Check pyScss --interactive failed"
    python -mscss -w tmp_dir &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -w failed"
    python -mscss --watch tmp_dir &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --watch failed"
    python -mscss -r &
    CHECK_RESULT $? 0 0 
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -r failed"
    python -mscss --recursive &
    CHECK_RESULT $? 0 0 
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --recursive failed"
    python -mscss -o output &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -o failed"
    python -mscss --output output &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss --output failed"
    python -mscss -s STRING &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "Check pyScss -s failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    rm -rf current-color.scss tmp_dir output
    pip3 uninstall -y pyScss
    LOG_INFO "End to restore the test environment."
}

main "$@"