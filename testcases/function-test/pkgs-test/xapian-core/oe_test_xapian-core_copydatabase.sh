#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
# http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhangchengjie&&zhuletian
#@Contact   	:   2281900936@qq.com
#@Date      	:   2022-08-15
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Take the test copydatabase command
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "xapian-core"
    cp -r ./common/db* ./
    LOG_INFO "End to prepare the test environmnet"
}

function run_test() {
    LOG_INFO "Start to run test"
    copydatabase --no-renumber ./db1 ./db2 result_file 2>&1 | grep -E "db1: 100/100|db2: 100/100"
    CHECK_RESULT $? 0 0 "option --no-renumber error"
    test -d result_file
    CHECK_RESULT $? 0 0 "Directory does not exist."
    copydatabase --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    copydatabase --version | grep copydatabase
    CHECK_RESULT $? 0 0 "option --version error"
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./result_file ./db*
    LOG_INFO "End to restore the test environment."
}

main "$@"
