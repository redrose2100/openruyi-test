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
# @Date      :   2025/11/03
# @License   :   Mulan PSL v2
# @Desc      :   test zopfli
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zopfli"
    echo "This is a test file for zopfli compression" > test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    zopfli test.txt
    CHECK_RESULT $? 0 0 "Basic compression execution failed"
    zopfli --gzip test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output gz format"
    zopfli --zlib test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output zlib format"
    zopfli --deflate test.txt
    CHECK_RESULT $? 0 0 "Failed to specify output deflate format"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.txt test.txt.deflate test.txt.gz test.txt.zlib 
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
