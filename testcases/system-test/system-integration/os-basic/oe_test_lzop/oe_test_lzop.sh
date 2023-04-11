#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023-04-11
# @License   :   Mulan PSL v2
# @Desc      :   function lzop
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch lzop_file
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lzop -v lzop_file
    test -e lzop_file.lzo
    CHECK_RESULT $? 0 0  "The lzop_file.lzo is not exit"
    lzop -t lzop_file.lzo
    CHECK_RESULT $? 0 0  "file2 result fail"
    lzop --ls lzop --ls lzop_file.lzo
    test -f lzop_file.lzo
    CHECK_RESULT $? 0 0 "check file2's help manual fail"
    echo "hello world" >>  lzop_file
    cat lzop_file | lzop > lzop_file2.lzo
    test -f lzop_file2.lzo
    CHECK_RESULT $? 0 0 "check lzop_file2.lzo help manual fail"
    lzop -dv lzop_file2.lzo
    test -f lzop_file2
    CHECK_RESULT $? 0 0 "check lzop_file2 help manual fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf lzop_file2.lzo lzop_file2 lzop_file lzop_file.lzo
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"



