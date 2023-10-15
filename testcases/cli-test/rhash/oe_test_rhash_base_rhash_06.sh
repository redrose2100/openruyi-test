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
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rhash --verbose --crc32 test1K.data 2>&1 | grep -E 'Config file: /etc/rhashrc|Config file:'
    CHECK_RESULT $? 0 0 "error --verbose"
    rhash --hex test1K.data 2>&1  | grep "test1K.data B70B4C26"
    CHECK_RESULT $? 0 0 "error --hex"
    rhash --base32 test1K.data 2>&1  | grep "test1K.data W4FUYJQ"
    CHECK_RESULT $? 0 0 "error --base32"
    rhash --base64 test1K.data 2>&1  | grep "test1K.data twtMJg=="
    CHECK_RESULT $? 0 0 "error --base64"
    rhash --magnet test1K.data 2>&1  | grep "magnet"
    CHECK_RESULT $? 0 0 "error --magnet"
    rhash --torrent tmp_dir/test1K.data 2>&1 
    CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/test1K.data.torrent')" 0 0 "error --torrent"
    rhash -a test1K.data > tmp_dir/file
    rhash --template tmp_dir/file tmp_dir/file 2>&1 | grep "test1K.data" 
    CHECK_RESULT $? 0 0 "error --template"
    rhash --printf "%f %C %M %H %E %G %T %A %W\n" test1K.data 2>&1  | grep -E '^test1K.data'
    CHECK_RESULT $? 0 0 "error --test1K.data"
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
