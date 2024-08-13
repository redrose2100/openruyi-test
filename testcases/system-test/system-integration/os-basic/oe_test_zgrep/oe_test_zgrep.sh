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
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-04-20
# @License   :   Mulan PSL v2
# @Desc      :   压缩文件搜索工具-zgrep
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
        cat >test.txt<<EOF
sdfassaaasd1223123223424435rrte
13cdeff
iAbc123
25timens01
EOF
    zip test.zip test.txt
    tar -cvf test.tar.gz test.txt
    xz  -k test.txt
    gzip -k test.txt
    bzip2 -k test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    zgrep assa test.zip
    CHECK_RESULT $? 0 0 "zgrep assa error" 
    zgrep -an "^[0-9]" test.tar.gz
    CHECK_RESULT $? 0 0 "zgrep tar.gz error"
    zgrep -ia "abc" test.tar.gz test.txt.xz
    CHECK_RESULT $? 0 0 "zgrep xz error"
    zgrep -an "^[0-9]" test.txt.gz | grep "2:"
    CHECK_RESULT $? 0 0 "zgrep gz error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
