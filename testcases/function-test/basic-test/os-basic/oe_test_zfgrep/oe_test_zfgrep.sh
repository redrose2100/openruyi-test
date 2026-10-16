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
# @Date      :   2024/2/23
# @License   :   Mulan PSL v2
# @Desc      :   Test zfgrep function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat << EOF > /tmp/testzfgrepfile.txt
line 1
Line 2
LIne 3
LINe 4
LINE 5
line 6
EOF
    zip /tmp/testzfgrepfile.zip /tmp/testzfgrepfile.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd /tmp || exit
    line=$(zfgrep -i "LINE" testzfgrepfile.zip | wc -l)
    CHECK_RESULT "${line}" 6 0 "zfgrep function error"
    zfgrep -i "line" testzfgrepfile.zip 
    CHECK_RESULT $? 0 0 "zfgrep function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testzfgrepfile.txt
    rm -rf /tmp/testzfgrepfile.zip
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

