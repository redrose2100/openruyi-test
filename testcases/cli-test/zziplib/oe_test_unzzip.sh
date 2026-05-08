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
# @Date      :   2025/07/25
# @License   :   Mulan PSL v2
# @Desc      :   test unzzip
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zziplib zip"
    mkdir -p /tmp/unzzip_test
    echo "Test content" > /tmp/unzzip_test/test.txt
    zip -j /tmp/unzzip_test/test.zip /tmp/unzzip_test/test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    unzzip --help >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Check help information"
    unzzip -l /tmp/unzzip_test/test.zip | grep -q "test.txt"
    CHECK_RESULT $? 0 0 "Check list function"
    mkdir -p /tmp/unzzip_test/extracted
    unzzip /tmp/unzzip_test/test.zip -d /tmp/unzzip_test/extracted
    CHECK_RESULT $? 0 0 "Check extraction"
    unzzip -p /tmp/unzzip_test/test.zip test.txt | grep -q "Test content"
    CHECK_RESULT $? 0 0 "Check pipe output"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf /tmp/unzzip_test
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
