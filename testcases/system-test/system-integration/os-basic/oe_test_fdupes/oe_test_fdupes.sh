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
# @Author    :   Elvis-surfing
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023-09-05
# @License   :   Mulan PSL v2
# @Desc      :   查找相同文件-fdupes
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL fdupes
    echo "hello" > /tmp/1.txt
    echo "hello" > /tmp/2.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    fdupes /tmp | grep $'/tmp/1.txt\n/tmp/2.txt'
    CHECK_RESULT $? 0 0 "fdupes function error"
    fdupes -r /tmp | grep $'/tmp/1.txt\n/tmp/2.txt'
    CHECK_RESULT $? 0 0 "fdupes function error"
    fdupes -n /tmp | grep $'/tmp/1.txt\n/tmp/2.txt'
    CHECK_RESULT $? 0 0 "fdupes function error"
    fdupes -S /tmp | grep $'/tmp/1.txt\n/tmp/2.txt'
    CHECK_RESULT $? 0 0 "fdupes function error"
    fdupes -dN /tmp | grep -
    CHECK_RESULT $? 0 0 "fdupes function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/1.txt
    rm -rf /tmp/2.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
