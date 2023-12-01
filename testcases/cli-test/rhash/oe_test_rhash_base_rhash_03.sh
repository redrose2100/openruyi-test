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
#@Date      	:   2022-017-25 
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
    rhash --version 2>&1 | grep "RHash v"
    CHECK_RESULT $? 0 0 "error --version"
    rhash --help 2>&1 | grep "Usage: rhash "
    CHECK_RESULT $? 0 0 "error --help"
    # Calculate checksum.
    rhash --crc32 test1K.data 2>&1 |grep "test1K.data B70B4C26"
    CHECK_RESULT $? 0 0 "error --crc32"
    rhash --crc32c test1K.data 2>&1 |grep "2cdf6e8f  test1K.data"
    CHECK_RESULT $? 0 0 "error --crc32c"
    # Calculate message digest.
    rhash --md4 test1K.data 2>&1 | grep "5ae257c47e9be1243ee32aabe408fb6b  test1K.data"
    CHECK_RESULT $? 0 0 "error --md4"
    rhash --md5 test1K.data 2>&1 | grep "b2ea9f7fcea831a4a63b213f41a8855b  test1K.data"
    CHECK_RESULT $? 0 0 "error --md5"
    rhash --sha1 test1K.data 2>&1 | grep "5b00669c480d5cffbdfa8bdba99561160f2d1b77  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha1"
    rhash --sha224 test1K.data 2>&1 | grep "6290817f6001432cd441058d2bb82d88b3f32425ade4c93d56207838  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha224"
    rhash --sha256 test1K.data 2>&1 | grep "785b0751fc2c53dc14a4ce3d800e69ef9ce1009eb327ccf458afe09c242c26c9  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha256"
    rhash --sha384 test1K.data 2>&1 | grep "55fd17eeb1611f9193f6ac600238ce63aa298c2e332f042b80c8f691f800e4c7505af20c1a86a31f08504587395f081f  test1K.data"
    CHECK_RESULT $? 0 0 "error --sha384"
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
