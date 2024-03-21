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
# @Author    :   qinjiaxi
# @Contact   :   qinjiaxi@uniontech.com
# @Date      :   2024-03-21
# @License   :   Mulan PSL v2
# @Desc      :   test tar
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tar
    mkdir -p /tmp/tar_test/dir
    touch /tmp/tar_test/file1.txt
    touch /tmp/tar_test/file2.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    tar -cvf test.tar /tmp/tar_test/dir /tmp/tar_test/file1.txt /tmp/tar_test/file2.txt
    ls test.tar
    CHECK_RESULT $? 0 0 "tar -cvf execute fail"
    tar -xvf test.tar
    cd tmp/tar_test && ls dir file1.txt file2.txt
    CHECK_RESULT $? 0 0 "tar -xvf execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    cd ../../ && rm -rf /tmp/tar_test tmp test.tar 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
