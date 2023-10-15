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
#@Desc      	:   Take the test xapian-compact command
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
    xapian-compact -b 16K db1 dbnew 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option-b is error"
    xapian-compact --blocksize 16K db1 dbnew 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option-blocksize is error"
    xapian-compact -F db1 dbnew1 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option-F is error"
    xapian-compact --fuller db1 dbnew1 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option--fuller is error"
    xapian-compact -n db1 dbnew2 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option-n is error"
    xapian-compact --no-full db1 dbnew2 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option--no-full is error"
    xapian-compact -m db1 dbnew2 dbnew3 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option--m is error"
    xapian-compact --multipass db1 dbnew2 dbnew3 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option--multipass is error"
    xapian-compact --no-renumber db1 dbnew4 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option--no-renumber is error"
    xapian-compact -s dbnew3 dbnew5 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option-s is error"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf $(ls | grep "db")
    DNF_REMOVE
    LOG_INFO "End to restore the test environment"
}

main "$@"