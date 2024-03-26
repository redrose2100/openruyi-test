#!/usr/bin/bash
# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hequan
# @Contact   :   hequan@uniontech.com
# @Date      :   2024-03-26
# @License   :   Mulan PSL v2
# @Desc      :   test bzdiff case
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "This is a test file." > file1.txt
    echo "This is another test file." > file2.txt
    bzip2 file1.txt
    bzip2 file2.txt
    cp file1.txt.bz2 file1.txt.copy.bz2
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    bzdiff file1.txt.bz2 file2.txt.bz2
    CHECK_RESULT $? 0 1 "bzdiff function error" 
    bzdiff file1.txt.bz2 file1.txt.copy.bz2
    CHECK_RESULT $? 0 0 "bzdiff function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf file1.txt.bz2 file2.txt.bz2 file1.txt.copy.bz2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
