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
#@Desc      	:   Take the test xapian-tcpsrv command
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
    xapian-tcpsrv --port 70 ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --port error"
    xapian-tcpsrv --interface 127.0.0.1 --port 71 ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --interface error"
    xapian-tcpsrv --port 72 --idle-timeout 5 ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --idle-timeout error"
    xapian-tcpsrv --port 74 --active-timeout 5 ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --active-timeout error"
    xapian-tcpsrv --port 75 --timeout 5 ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --timeout error" 
    xapian-tcpsrv --port 76 --one-shot ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --one-shot error" 
    xapian-tcpsrv --port 77 --quiet ./db1 2>&1 &
    CHECK_RESULT $? 0 0 "option --quiet error" 
    xapian-tcpsrv --port 78 --writable ./db1 2>&1 | grep -E "Listening" &
    CHECK_RESULT $? 0 0 "option --writable error" 
    xapian-tcpsrv --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    xapian-tcpsrv --version | grep xapian-tcpsrv
    CHECK_RESULT $? 0 0 "option --version error"
    LOG_INFO "End to run test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pidof xapian-tcpsrv)
    rm -rf ./db1
    LOG_INFO "End to restore the test environment."
}

main "$@"