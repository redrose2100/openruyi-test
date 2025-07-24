#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/07/23
# @License   :   Mulan PSL v2
# @Desc      :   test zziplib
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zziplib zip"
    echo "Test file 1 content" > /tmp/test_file1.txt
    echo "Test file 2 content" > /tmp/test_file2.txt
    zip -j /tmp/test_archive.zip /tmp/test_file1.txt /tmp/test_file2.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    unzip-mem -l /tmp/test_archive.zip | grep -q "test_file1.txt"
    CHECK_RESULT $? 0 0 "ZIP content listing test failed"
    unzip-mem -p /tmp/test_archive.zip test_file1.txt | grep -q "Test file 1 content"
    CHECK_RESULT $? 0 0 "File extraction test failed"
    unzip-mem -t /tmp/test_archive.zip    
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf /tmp/test_file1.txt /tmp/test_file2.txt /tmp/test_archive.zip 
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

