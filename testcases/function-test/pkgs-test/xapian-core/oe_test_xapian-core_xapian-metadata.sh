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
#@Desc      	:   Take the test xapian-metadata command and xapian-replicate --help,xapian-replicate --version
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
    xapian-metadata set ./db1 id_NUMBER 123456 2>&1
    CHECK_RESULT $? 0 0 "option set error"
    xapian-metadata list ./db1 id_NUMBER 2>&1 | grep -E "id_NUMBER"
    CHECK_RESULT $? 0 0 "option list error"
    xapian-metadata get ./db1 id_NUMBER 2>&1 | grep -E "[0-9]"
    CHECK_RESULT $? 0 0 "option get error"
    xapian-replicate --help | grep Usage
    CHECK_RESULT $? 0 0 "option --help error"
    xapian-replicate --version | grep xapian-replicate
    CHECK_RESULT $? 0 0 "option --version error"
    LOG_INFO "End to run the test"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./db1
    LOG_INFO "End to restore the test environment."
}

main "$@"