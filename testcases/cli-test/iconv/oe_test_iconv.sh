#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024-09-12
# @License   :   Mulan PSL v2
# @Desc      :   test iconv
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function run_test() {
    LOG_INFO "Start testing..."
    iconv --help
    CHECK_RESULT $? 0 0 "iconv execute fail"
    iconv --list
    CHECK_RESULT $? 0 0 "iconv execute fail"
    touch input.txt
    echo "Hello, World!" > input.txt
    iconv -f UTF-8 -t GB2312 input.txt -o output.txt
    CHECK_RESULT $? 0 0 "iconv execute fail"
    cat output.txt
    CHECK_RESULT $? 0 0 "output.txt generation failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf input.txt
    rm -rf output.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"