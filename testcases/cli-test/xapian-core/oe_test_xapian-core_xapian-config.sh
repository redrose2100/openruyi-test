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
#@Desc      	:   Take the test xapian-config command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "xapian-core"
    LOG_INFO "End to prepare the test environment"
}

function run_test()
{
    LOG_INFO "Start to run test."
    xapian-config --cxxflags 2>&1
    CHECK_RESULT $? 0 0 "option --cxxflags error"
    xapian-config --libs 2>&1 | grep -E "/"
    CHECK_RESULT $? 0 0 "option --libs error"
    xapian-config --ltlibs 2>&1 | grep -E "/"
    CHECK_RESULT $? 0 0 "option --ltlibs error"
    xapian-config --static --libs 2>&1 | grep -E "/"
    CHECK_RESULT $? 0 0 "option --static error"
    xapian-config --swigflags 2>&1 | grep -E "/"
    CHECK_RESULT $? 0 0 "option --swigflags error"
    xapian-config --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    xapian-config --version | grep xapian-config
    CHECK_RESULT $? 0 0 "option --version error"
    LOG_INFO "End to run test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment"
}

main "$@"