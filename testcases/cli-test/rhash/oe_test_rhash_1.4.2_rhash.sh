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
    #This test case is conducted in the openEuler 22.03 LTS  environment for the rhash-1.4.2 version
    LOG_INFO "Start to run test."
    # calculate  message digest
    rhash --blake2s test1K.data 2>&1 | grep "a049455add68f38d48845e25a52ba3100c4d0899178c202aec07364fecacf650  test1K.data"
    CHECK_RESULT $? 0 0 "error --blake2s"
    rhash --blake2b test1K.data 2>&1 | grep "6b490f42e902f61b1ee12d3c85e34152e37c94d07ab9ea577cad6a6eb4690fad38064f53a19c225703a5c52cdc9a85add71b339d327e1630ee3432b920240e8a  test1K.data"
    CHECK_RESULT $? 0 0 "error --blake2b"
    rhash --edonr512 test1K.data 2>&1 | grep "9052ac32582d303e8220b7b1d3b187b2b7a43239bbb708222346db056c852be989d4ffe00df31fe80789a568096a0c4ff6dabcf77419b66bc28db871b49386e2  test1K.data"
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
