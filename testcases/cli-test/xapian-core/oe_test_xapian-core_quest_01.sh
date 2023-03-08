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
    quest -d ./db 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -d error"
    quest --db=./db 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --db= error"
    quest -d ./db -m 3 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -m error"
    quest -d ./db --msize=3 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --msize= error"
    quest -d ./db -c 2 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -c error"
    quest -d ./db --check-at-least=2 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --check-at-least= error"
    quest -d ./db -s english 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -s error"
    quest -d ./db --stemmer=english 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --stemmer= error"
    quest -d ./db -p x:l 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option -p error"
    quest -d ./db --prefix=x:l 'x' 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option --prefix= error"
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