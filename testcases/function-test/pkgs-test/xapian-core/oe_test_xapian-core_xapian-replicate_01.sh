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
#@Desc      	:   Take the test xapian-replicate command
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "xapian-core"
    for i in {1..8}; do
        cp -rf ./common/db1 db"$i"
    done
    xapian-replicate-server -I 127.0.0.1 -p 73 ./ &
    LOG_INFO "End to prepare the test environmnet"
}
function run_test()
{
    LOG_INFO "Start to run test"
    xapian-replicate -h 127.0.0.1 -p 73 -m ./db1 copydb1 &
    CHECK_RESULT $? 0 0 "option -h,-p,-m error" 
    xapian-replicate -h 127.0.0.1 -p 73  -i 60 -m ./db2 copydb2 &
    CHECK_RESULT $? 0 0 "option -i error" 
    xapian-replicate -h 127.0.0.1 -p 73 -r 3 -m ./db3 copydb3 &
    CHECK_RESULT $? 0 0 "option -r error"
    xapian-replicate -h 127.0.0.1 -p 73 -t 3 -m ./db4 copydb4 &
    CHECK_RESULT $? 0 0 "option -t error"
    xapian-replicate -h 127.0.0.1 -p 73 -f -m ./db5 copydb5 &
    CHECK_RESULT $? 0 0 "option -f error"
    xapian-replicate -h 127.0.0.1 -p 73 -o -m ./db6 copydb6 &
    CHECK_RESULT $? 0 0 "option -o error"  
    xapian-replicate -h 127.0.0.1 -p 73 -q -m ./db7 copydb7 &   
    CHECK_RESULT $? 0 0 "option -q error"
    xapian-replicate -h 127.0.0.1 -p 73 -v -m ./db8 copydb8 & 
    CHECK_RESULT $? 0 0 "option -v error"
    LOG_INFO "End to run test"
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pidof xapian-replicate xapian-replicate-server)
    rm -rf $(ls | grep "db")
    LOG_INFO "End to restore the test environment."
}

main "$@"