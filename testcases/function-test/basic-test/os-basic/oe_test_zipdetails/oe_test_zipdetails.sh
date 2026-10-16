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
# @Date      :   2023-06-19
# @License   :   Mulan PSL v2
# @Desc      :   显示zip文件内部结构-zipdetails
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cd /tmp || exit
    echo "sdfassaaasd1223123223424435rrte" > test.txt
    zip test.zip test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    cd /tmp || exit
    zipdetails test.zip|grep PAYLOAD
    CHECK_RESULT $? 0 0 "zipdetails function error"
    zipdetails -v test.zip|grep PAYLOAD
    CHECK_RESULT $? 0 0 "zipdetails function error"
    zipdetails --redact test.zip |grep HEADER
    CHECK_RESULT $? 0 0 "zipdetails function error"
    zipdetails --scan test.zip |grep LOCAL
    CHECK_RESULT $? 0 0 "zipdetails function error"
    zipdetails --utc test.zip |grep Extract
    CHECK_RESULT $? 0 0 "zipdetails function error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt
    rm -rf /tmp/test.zip
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
