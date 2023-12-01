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
#@Desc      	:   Take the test xapian-delve command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    cp -r ./common/db1 db1
    DNF_INSTALL "xapian-core"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    xapian-delve -a ./db1 2>&1 | grep -E "All terms"
    CHECK_RESULT $? 0 0 "option-a is error"
    xapian-delve -A x ./db1 2>&1 | grep -E "All terms"
    CHECK_RESULT $? 0 0 "option-A is error"
    xapian-delve -r 1 ./db1 2>&1 | grep -E "Term List"
    CHECK_RESULT $? 0 0 "option-r is error"
    xapian-delve -t x ./db1 2>&1 | grep -E "Posting List"
    CHECK_RESULT $? 0 0 "option-t is error"
    xapian-delve -t x -r 1 ./db1 2>&1 | grep -E "doesn't|Position List"
    CHECK_RESULT $? 0 0 "option-t-r is error"
    xapian-delve -s english ./db1 2>&1 | grep -E "UUID"
    CHECK_RESULT $? 0 0 "option-s is error"
    xapian-delve -1 ./db1 2>&1 | grep -E "UUID"
    CHECK_RESULT $? 0 0 "option-l is error"
    xapian-delve -V ./db1 2>&1 | grep -E "UUID"
    CHECK_RESULT $? 0 0 "option-V is error"
    xapian-delve -d ./db1 2>&1 | grep -E "UUID"
    CHECK_RESULT $? 0 0 "option-d is error"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf db1
    LOG_INFO "End to restore the test environment."
}

main "$@"