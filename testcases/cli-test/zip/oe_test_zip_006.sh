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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2024-12-11
# @License   :   Mulan PSL v2
# @Desc      :   Encrypt and decrypt zip
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    dd if=/dev/zero of=testfile.txt bs=1M count=100
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    zip -0 testfile_0.zip testfile.txt
    test -e testfile_0.zip
    CHECK_RESULT $? 0 0 "zip -0 is failed!"
    zip -1 testfile_1.zip testfile.txt
    test -e testfile_1.zip
    CHECK_RESULT $? 0 0 "zip -1 is failed!"
    zip -6 testfile_6.zip testfile.txt
    test -e testfile_6.zip
    CHECK_RESULT $? 0 0 "zip -6 is failed!"
    zip -9 testfile_9.zip testfile.txt
    test -e testfile_9.zip
    CHECK_RESULT $? 0 0 "zip -9 failed!"
    size_6=$(stat -c %s testfile_6.zip)
    size_9=$(stat -c %s testfile_9.zip)
    size_0=$(stat -c %s testfile_0.zip)
    size_1=$(stat -c %s testfile_1.zip)
    ((size_6 >= size_9))
    CHECK_RESULT $? 0 0 "zip -9 compression capacity error"
    ((size_6 <= size_0))
    CHECK_RESULT $? 0 0 "zip -0 compression capacity error"
    ((size_6 <= size_1))
    CHECK_RESULT $? 0 0 "zip -1 compression capacity error"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf testfile*
    LOG_INFO "End to restore the test environment."
}

main "$@"
