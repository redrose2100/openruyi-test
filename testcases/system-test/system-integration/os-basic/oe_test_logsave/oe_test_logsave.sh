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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/11/05
# @License   :   Mulan PSL v2
# @Desc      :   Using the logsave command
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function run_test() {
    LOG_INFO "Start to run test."
    logsave log.txt ls -l
    grep Log log.txt
    CHECK_RESULT $? 0 0 "File view failed"
    logsave -a log.txt df -h
    grep 文件系统 log.txt
    CHECK_RESULT $? 0 0 "File view failed"
    logsave -c log.txt ps aux
    grep usr log.txt
    CHECK_RESULT $? 0 0 "File view failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf log.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"