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
#@Desc      	:   Take the test xapian-pos command
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
    xapian-pos --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help is error"
    xapian-pos --version | grep xapian-pos
    CHECK_RESULT $? 0 0 "option --vresion is error "
    xapian-pos --doc=1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option --doc is error"
    xapian-pos -d 1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option -d is error"
    xapian-pos --start=15 --doc=1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option --start is error"
    xapian-pos -s 15 --doc=1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option -s is error"
    xapian-pos -e 15 --doc=1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option -e is error"
    xapian-pos --end=15 --doc=1 ./db1 2>&1 | grep -E "positions"
    CHECK_RESULT $? 0 0 "option --end is error"
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