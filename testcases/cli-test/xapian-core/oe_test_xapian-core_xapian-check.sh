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
#@Desc      	:   Take the test xapian-check command
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
    xapian-check ./db F 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option F error"
    xapian-check ./db t 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option t error"   
    xapian-check ./db f 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option f error"
    xapian-check ./db b 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option b error"
    xapian-check ./db v 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option v error"
    xapian-check ./db + 2>&1 | grep -E "No errors found"
    CHECK_RESULT $? 0 0 "option + error"
    LOG_INFO "End to run test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./db
    LOG_INFO "End to restore the test environment"
}

main "$@"