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
#@Desc      	:   Take the test quest command
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "xapian-core"
    cp -r ./common/db1 db
    LOG_INFO "End to prepare the test environmnet"
}

function run_test()
{
    LOG_INFO "Start to run test"
    quest -d ./db -b a:n 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -b error"
    quest -d ./db --boolean-prefix=a:n 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --boolean-prefix= error"
    quest -d ./db -f default 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -f error"
    quest -d ./db --flags=default 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --flags= error"
    quest -d ./db -o and 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -o error"
    quest -d ./db --default-op=and 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --default-op= error"
    quest -d ./db -w bb2 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -w error"
    quest -d ./db --weight=bb2 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --weight= error"
    quest --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    quest -h |grep Usage
    CHECK_RESULT $? 0 0 "option -h error"
    LOG_INFO "End to run test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./db
    LOG_INFO "End to restore the test environment."
}

main "$@"