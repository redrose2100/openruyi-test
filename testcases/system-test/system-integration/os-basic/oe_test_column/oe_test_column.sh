#!/usr/bin/bash
# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024-08-02
# @License   :   Mulan PSL v2
# @Desc      :   column命令-输入格式化为多个列
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    input_data="1231223122231222231222223"
    echo "$input_data" | column -s 3 -t > "/tmp/1.txt"
    grep "12" "/tmp/1.txt"
    CHECK_RESULT $? 0 0 "column function error"
    expected="12  122  1222  12222  122222"
    actual=$(head -n 1 "/tmp/1.txt" | sed 's/ *$//')
    [ "$actual" = "$expected" ]
    CHECK_RESULT $? 0 0 "Column alignment failed. Expected: '$expected', Got: '$actual'"
    echo -e "123\n456\n789" | column -s 3 -t > "/tmp/2.txt"
    line_count=$(wc -l < "/tmp/2.txt")
    CHECK_RESULT "$line_count" 3 0 "Multi-line processing failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf "/tmp/1.txt" "/tmp/2.txt"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
