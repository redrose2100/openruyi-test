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
# @Desc      :   zipinfo命令 – 查看压缩文件信息
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "zip unzip"
    echo "aabbcc" >/tmp/test.txt
    zip /tmp/test.zip /tmp/test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    zipinfo /tmp/test.zip |grep compressed
    CHECK_RESULT $? 0 0 "zipinfo function error"
    zipinfo -h /tmp/test.zip |grep "number of entries"
    CHECK_RESULT $? 0 0 "zipinfo function error"
    zipinfo -s /tmp/test.zip |grep "bytes"
    CHECK_RESULT $? 0 0 "bytes function error"
    zipinfo -m /tmp/test.zip |grep "uncompressed"
    CHECK_RESULT $? 0 0 "uncompressd function error"
    zipinfo -1 /tmp/test.zip |grep -w "tmp/test.txt"
    CHECK_RESULT $? 0 0 "zipinfo -l command execution failure"
    zipinfo -v /tmp/test.zip |grep "tmp/test.txt"
    CHECK_RESULT $? 0 0 "zipinfo -v command execution failure"
    zipinfo -l /tmp/test.zip |grep Archive
    CHECK_RESULT $? 0 0 "zipinfo -l command execution failure"
    zipinfo -z /tmp/test.zip |grep "tmp/test.txt"
    CHECK_RESULT $? 0 0 "zipinfo -z command execution failure"
    zipinfo -C /tmp/test.zip |grep "Archive"
    CHECK_RESULT $? 0 0 "zipinfo -C command execution failure"
    zipinfo -t /tmp/test.zip |grep "file"
    CHECK_RESULT $? 0 0 "zipinfo -t command execution failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt
    rm -rf /tmp/test.zip
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
