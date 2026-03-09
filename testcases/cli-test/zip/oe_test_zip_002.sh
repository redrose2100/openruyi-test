#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2024-05-07
# @License   :   Mulan PSL v2
# @Desc      :   Encrypt and decrypt zip
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    mkdir testdata
    echo "test content" > test.txt
    echo "delete content" > test2.txt
    DNF_INSTALL unzip
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    zip testdatabak.zip testdata
    test -e testdatabak.zip
    CHECK_RESULT $? 0 0 "zip is failed!"
    zip -u testdatabak.zip test.txt
    CHECK_RESULT $? 0 0 "testdatabak.zip update is failed!"
    zip -T testdatabak.zip
    CHECK_RESULT $? 0 0 "zip test integrity is failed!"
    zip -P 123456 test_pwd.zip test.txt
    CHECK_RESULT $? 0 0 "zip encryption is failed!"
    mkdir extract_dir
    (
    cd extract_dir || return
    unzip -P 123456 ../test_pwd.zip
    CHECK_RESULT $? 0 0 "unzip decryption is failed!"
    )
    test -f extract_dir/test.txt
    CHECK_RESULT $? 0 0 "unzip extract file check is failed!"
    zip -v test_verbose.zip test.txt | grep -E 'in=[0-9]*'
    CHECK_RESULT $? 0 0 "zip verbose mode is failed!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf testdata testdatabak.zip test.txt test2.txt test_level.zip test_pwd.zip test_del.zip test_verbose.zip extract_dir
    LOG_INFO "End to restore the test environment."
}

main "$@"
