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
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rhash --sha512 test1K.data 2>&1 | grep "37f652be867f28ed033269cbba201af2112c2b3fd334a89fd2f757938ddee815787cc61d6e24a8a33340d0f7e86ffc058816b88530766ba6e231620a130b566c  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha512"
    rhash --sha3-224 test1K.data 2>&1 | grep "5b37c09e5b5cf21b0d8097e9479fe6982003b617d41ab2293d77bf22  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha3-224"
    rhash --sha3-256 test1K.data 2>&1 | grep "b6c70631c6ff932b9f380d9cde8750eb9bea393817a9aea410c2119eb7b9b870  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha3-256"
    rhash --sha3-384 test1K.data 2>&1 | grep "bfdb44fcb75b4a02db0487b0c607630283ae792bbef4797bd993009a2fd15cf2425b1a9f82f25f6cdc7cac15be3d572e  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha3-384"
    rhash --sha3-512 test1K.data 2>&1 | grep "b052fd4a09f988bbe4112d9a3eca8ccc517e56da866c1609504c37871146da80731bb681674a2000a41bcb78230b3d9069eb42820293ce23cba294550a1d4d3b  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha3-512"
    rhash --tth test1K.data 2>&1 | grep "4oqy25un2xhidqpv5u6bxaz47inucygibk7lfni  test1K.data"
    CHECK_RESULT $? 0 0 "error --tth"
    rhash --btih test1K.data 2>&1 | grep "33e75b119aa12c75391d662b341ee0af8203ec13  test1K.data"
    CHECK_RESULT $? 0 0 "error --btih"
    rhash --aich test1K.data 2>&1 | grep "lmagnhcibvop7pp2rpn2tflbcyhs2g3x  test1K.data"
    CHECK_RESULT $? 0 0 "error --aich"
    rhash --ed2k test1K.data 2>&1 | grep "5ae257c47e9be1243ee32aabe408fb6b  test1K.data"
    CHECK_RESULT $? 0 0 "error --ed2k"
    rhash --ed2k-link test1K.data 2>&1 | grep "ed2k://|file|test1K.data|1024|5ae257c47e9be1243ee32aabe408fb6b|h=lmagnhcibvop7pp2rpn2tflbcyhs2g3x|/"
    CHECK_RESULT $? 0 0 "error --ed2k-link"
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
