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
# @Date      :   2024/4/3
# @License   :   Mulan PSL v2
# @Desc      :   Test zfgrep function
# #############################################


source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat << EOF > /tmp/testfile.txt
line 1
Line 2
LIne 3
LINe 4
LINE 5
EOF
    xz /tmp/testfile.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd /tmp || exit
    xzgrep "line" testfile.txt.xz
    CHECK_RESULT $? 0 0 "xzgrep function error"
    line=$(xzgrep -i "LINE" testfile.txt.xz| wc -l)
    CHECK_RESULT "${line}" 5 0 "xzgrep function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testfile.txt.xz
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

