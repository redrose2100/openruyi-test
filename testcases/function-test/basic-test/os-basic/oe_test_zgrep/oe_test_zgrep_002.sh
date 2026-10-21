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
# @Date      :   2023-08-17
# @License   :   Mulan PSL v2
# @Desc      :   压缩文件搜索工具-zgrep
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "zip"
    cd /tmp || return
    cat << EOF > /tmp/test.txt
This is line 1.
This is Line 2.
This is LINE 3.
This is Line 4.
EOF
    zip test.zip test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd /tmp || exit
    line=$(zgrep -i "LINE" test.zip | wc -l)
    CHECK_RESULT "${line}" 4 0 "zgrep function error"
    zgrep -v "line" test.zip | grep 3
    CHECK_RESULT $? 0 0 "zgrep function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt
    rm -rf /tmp/test.zip
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

