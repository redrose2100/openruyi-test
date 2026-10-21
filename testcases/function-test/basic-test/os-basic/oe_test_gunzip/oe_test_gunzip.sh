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
# @Date      :   2024-05-09
# @License   :   Mulan PSL v2
# @Desc      :   gunzip命令 – 解压提取文件内容
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "aabbcc" >/tmp/test.txt
    echo "aabbccddeeff" >/tmp/test2.txt
    echo "hello" >/tmp/test3.txt
    gzip /tmp/test.txt /tmp/test2.txt /tmp/test3.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    gunzip -v /tmp/test.txt.gz
    CHECK_RESULT $? 0 0 "gunzip function error"
    gunzip -c /tmp/test2.txt.gz > /var/test123.txt
    CHECK_RESULT $? 0 0  "check test123.txt exist"
    gunzip -k /tmp/test3.txt.gz
    CHECK_RESULT $? 0 0  "check test3.txt.gz test3.txt exist"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test*
    rm -rf /var/test123.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
