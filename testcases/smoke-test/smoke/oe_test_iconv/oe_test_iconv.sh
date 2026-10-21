#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-09-24
#@License   	:   Mulan PSL v2
#@Desc      	:   test iconv
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    file1="/tmp/test_file1"
    file2="/tmp/test_file2"
    file3="/tmp/test_file3"
    echo "0123456789abcdefghijklmnOPQRSTUVWXYZ$%^&*()_+{}|?><,./';\][ÖÐ¹ú" > "$file1"
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    iconv -l
    CHECK_RESULT $? 0 0  "iconv: check arguments -l fail"

    iconv -f GBK -t UTF-8 -c "$file1" -o "$file2"
    CHECK_RESULT $? 0 0  "iconv: check arguments -f,-t,-c,-o fail"
    iconv -f UTF-8 -t GBK -c "$file2" -o "$file3"
    CHECK_RESULT $? 0 0  "iconv: check arguments -f,-t,-c,-o fail"

    file_charSet=$(file "$file2")
    test "UTF-8" != "$file_charSet" && test "$file2" == "$(echo "$file_charSet" | awk -F":" '{print $1}')"
    CHECK_RESULT $? 0 0  "iconv: check converted file2 charSet fail"

    test "$(diff "$file1" "$file3")" == ""
    CHECK_RESULT $? 0 0  "iconv: check converted file1 and file3 are equal fail"

    iconv -l |shuf -n 50 | awk -F"/" '{print $1}' | while IFS= read -r line; do
       iconv -f GBK -t "$line" "$file1" -o "$file2"
       CHECK_RESULT $? 0 0  "iconv: check random charSet:$line convert fail"
    done

    iconv -V | grep "iconv"
    CHECK_RESULT $? 0 0  "iconv: check arguments -V fail"
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    unset file1 file2 file3
    rm -rf /tmp/test_file1 /tmp/test_file2 /tmp/test_file3
    LOG_INFO "Finish restoring environment."
}

main "$@"



