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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2022-03-06
# @License   :   Mulan PSL v2
# @Desc      :   package lzo-lzop test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lzo lzop"
    touch lzop_file
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    lzop -v lzop_file
    CHECK_RESULT $? 0 0 "Failed to compress the file and output details"
    lzop -t lzop_file.lzo
    CHECK_RESULT $? 0 0 "Compressed file integrity test failed"
    lzop --ls lzop_file.lzo
    CHECK_RESULT $? 0 0 "Failed to list the contents of the compressed file"
    echo "hello world" >>  lzop_file
    CHECK_RESULT $? 0 0 "fail to write to file"
    cat lzop_file | lzop > lzop_file2.lzo
    CHECK_RESULT $? 0 0 "View file error"
    test -e lzop_file2.lzo
    CHECK_RESULT $? 0 0 "lzop_ File2.lzo compressed file creation failed"
    lzop -dv lzop_file2.lzo
    CHECK_RESULT $? 0 0 "Failed to extract the file"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment." 
    rm -rf  lzop_file2 lzop_file2.lzo lzop_file.lzo lzop_file
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main $@
