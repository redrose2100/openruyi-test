#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-05-27
# @License   :   Mulan PSL v2
# @Desc      :   Command test-fincore
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    echo 4444 > test1
    CHECK_RESULT $? 0 0 "new file succeeded"
    fincore test1 |grep 4K
    CHECK_RESULT $? 0 0 "file creation failure"
    fincore -J  test1 |grep '"res": "4K"'
    CHECK_RESULT $? 0 0 "failed to delete columns 3 through 6 from the file"
    fincore -b test1 |grep 4096
    CHECK_RESULT $? 0 0 "description failed to view the dc help information"
    fincore -n test1|grep RES
    CHECK_RESULT $? 0 1 "description failed to view the dc version"
    fincore test1 -o size|grep SIZE
    CHECK_RESULT $? 0 0 "description failed to view the dc help information"
    fincore -V|grep fincore
    CHECK_RESULT $? 0 0 "description failed to view the dc version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    rm -rf test1
    LOG_INFO "End to clean the test environment."
}

main "$@"


