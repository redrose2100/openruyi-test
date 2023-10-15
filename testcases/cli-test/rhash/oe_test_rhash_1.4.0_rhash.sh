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
    #Compared with rhash-1.4.2, rhash-1.4.0 has no "blake2b" and "blake2s" command parameter, the use of "edonr512" is different
    LOG_INFO "Start to prepare the test environment."
    cp -f ./common/test1K.data .
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    #This test case is conducted in the openEuler 20.03 LTS SP3 environment for the rhash-1.4.0 version
    LOG_INFO "Start to run test."
    # calculate  message digest
    rhash --edonr512 test1K.data 2>&1 | grep "cd0f7ecf145c769e462cb3d1cda0a7fb5503c11b0e29e0fe9071c27e07a74f2448686a2e54619dcee8ffcbc1012f6b393faf5e40de01f76f8c75689684c161e2  test1K.data"
    CHECK_RESULT $? 0 0 "error --edonr512"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test1K.data
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"
