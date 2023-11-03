#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   czjoyit@qq.com
#@Contact   	:   czjoyit@qq.com
#@Date      	:   2022/07/26
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Take the test rhash command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    #In the openEuler 22.03 LTS system, the version of the rhash is rhash-1.4.2
    #In the openEuler 20.03 LTS SP3 system, the version of the rhash is rhash-1.4.0
    LOG_INFO "Start to prepare the test environment."
    cp -f ./common/test1K.data .
    mkdir tmp_dir&&cp -f test1K.data tmp_dir/
    cp tmp_dir/test1K.data tmp_dir/test1K.data2
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rhash --maxdepth 1 --recursive tmp_dir 2>&1 | grep "tmp_dir"
    CHECK_RESULT $? 0 0 "error recursive or error --maxdepth"
    rhash --file-list tmp_dir/test1K.data tmp_dir/test1K.data2 2>&1 | grep -E 'test1K.data|test1k.data2'
    CHECK_RESULT $? 0 0 "error --file-list"
    rhash test1K.data | rhash --skip-ok --check - | grep -v "test1K.data"
    CHECK_RESULT $? 0 0 "error -skip-ok"
    rhash --message 'test_message' 2>&1 | grep "(message) 6AFCE4B7"
    CHECK_RESULT $? 0 0 "error --message"
    rhash --percents --speed test1K.data 2>&1 | grep -E '^Calculated in|test1K.data'
    CHECK_RESULT $? 0 0 "error --percents or error --speeds"
    rhash --output tmp_dir/tmp_output test1K.data 2>&1
    CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/tmp_output')" 0 0 "error--output"
    rhash --log tmp_dir/tmp_log test1K.data 2>&1
    CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/tmp_log')" 0 0 "error--output"
    rhash --bsd test1K.data 2>&1 | grep "CRC32 (test1K.data) = b70b4c26"
    CHECK_RESULT $? 0 0 "error --bsd"
    rhash --sfv test1K.data 2>&1 | grep "test1K.data B70B4C26"
    CHECK_RESULT $? 0 0 "error --sfv"
    rhash --simple test1K.data 2>&1 | grep "b70b4c26  test1K.data"
    CHECK_RESULT $? 0 0 "error --simple"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test1K.data tmp_dir
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
