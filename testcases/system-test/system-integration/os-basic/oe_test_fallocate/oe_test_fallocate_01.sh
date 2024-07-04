#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ut004871
# @Contact   :   liliqi@uniontech.com
# @Date      :   2024-07-02
# @License   :   Mulan PSL v2
# @Desc      :   Command test-fallocate
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}



function run_test() {
    LOG_INFO "Start to run test."
    fallocate -v -l 100M test1.txt
    du -sh test1.txt | awk '{print $1}' | grep -i '100M'
    CHECK_RESULT $? 0 0  "check test1.txt 100M failed"
    fallocate -d test1.txt
    CHECK_RESULT $? 0 0  "fallocate failed to execute"
    fallocate -p -o 100 -l 100 test1.txt
    CHECK_RESULT $? 0 0  "check test1.txt failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    LOG_INFO "start environment cleanup!"
    rm -rf  test1.txt
    LOG_INFO "Finish environment cleanup!"

}

main "$@"
