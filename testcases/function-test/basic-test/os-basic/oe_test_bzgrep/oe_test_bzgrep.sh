#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2024-02-23
# @License   :   Mulan PSL v2
# @Desc      :   压缩文件搜索工具-bzgrep
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo -e "abc \\ndef \\nghi" > /tmp/test.txt
    bzip2 /tmp/test.txt
    echo -e "123 \\n123 \\" > /tmp/test2.txt
    bzip2 /tmp/test2.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    bzgrep abc /tmp/test.txt.bz2
    CHECK_RESULT $? 0 0 "bzgrep function error"
    bzgrep -i ABC /tmp/test.txt.bz2
    CHECK_RESULT $? 0 0 "ABC not found"
    bzgrep -n 'ghi' /tmp/test.txt.bz2 | grep '3:ghi'
    CHECK_RESULT $? 0 0 "Failed to return line number"
    bzgrep -l 123 /tmp/test.txt.bz2 /tmp/test2.txt.bz2 | grep 'test2.txt.bz2'
    CHECK_RESULT $? 0 0 "Query failure"
    bzgrep -r ndef /tmp/test.txt.bz2
    CHECK_RESULT $? 0 0 "Query failure"
    nums=$(bzgrep -c 123 /tmp/test2.txt.bz2)
    CHECK_RESULT "$nums" 2 0 "Query failure"
    result=$(bzgrep -v "123" /tmp/test2.txt.bz2)
    CHECK_RESULT "$result" "" 0 "Query failure"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt.bz2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
