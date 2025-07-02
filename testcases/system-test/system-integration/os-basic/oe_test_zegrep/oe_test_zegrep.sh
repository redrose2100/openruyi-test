#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   2024/1/18
# @License   :   Mulan PSL v2
# @Desc      :   Test zegrep function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL zip
    cat <<EOF >/tmp/testfile.txt
line 1
Line 2
LIne 3
LINe 4
LINE 5
EOF
    zip /tmp/testfile.zip /tmp/testfile.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp || exit
    line=$(zegrep -i "LINE" testfile.zip | wc -l)
    CHECK_RESULT "${line}" 5 0 "zegrep function error"
    zegrep -i "line" testfile.zip
    CHECK_RESULT $? 0 0 "zegrep function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testfile.txt /tmp/testfile.zip
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
