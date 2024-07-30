#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-tar
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "tar"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    mkdir -p /tmp/test
    dd if=/dev/zero of=/tmp/test/test count=1 bs=512
    tar -cf test.tar /tmp/test/test
    touch file1 /tmp/test
    ls test.tar
    CHECK_RESULT $? 0 0 "tar -cf execute fail"
    tar -tvf test.tar | grep "test"
    CHECK_RESULT $? 0 0 "tar -tvf execute fail"
    tar --help | grep "Usage"
    CHECK_RESULT $? 0 0 "tar --help execute fail"
    tar --usage
    CHECK_RESULT $? 0 0 "tar --usage execute fail"
    tar -rvf test.tar file1 | grep "file1"
    CHECK_RESULT $? 0 0 "tar -rvf execute fail"
    tar --list -f test.tar | grep "file1"
    CHECK_RESULT $? 0 0 "tar --list execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test test.tar file1
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
