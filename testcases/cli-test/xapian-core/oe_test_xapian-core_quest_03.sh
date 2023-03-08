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
#@Desc      	:   Take the test xapian-quest command and xapian-compact command
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "xapian-core"
    cp -r ./common/db1 db1
    LOG_INFO "End to prepare the test environmnet"
}

function run_test()
{
    LOG_INFO "Start to run test"
    quest --version | grep quest
    CHECK_RESULT $? 0 0 "option --version error"
    quest -v| grep quest
    CHECK_RESULT $? 0 0 "option -v error"
    xapian-compact --single-file db1 db2 2>&1 | grep -E "postlist"
    CHECK_RESULT $? 0 0 "option --single-flie is error"
    xapian-compact --help | grep Usage
    CHECK_RESULT $? 0 0 "option--help is error"
    xapian-compact --version | grep xapian-compact
    CHECK_RESULT $? 0 0 "option--version is error"
    LOG_INFO "End to run test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./db[1..2]
    LOG_INFO "End to restore the test environment"
}

main "$@"