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
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023-06-13
# @License   :   Mulan PSL v2
# @Desc      :   dosfsck command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dosfstools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=/tmp/300k bs=1k count=100
    CHECK_RESULT $? 0 0 "dd command execution failed"
    echo y | mke2fs /tmp/300k
    mkdosfs -n test /tmp/300k
    CHECK_RESULT $? 0 0 "mkdosfs command execution failed"
    file /tmp/300k | grep mkfs.fat
    CHECK_RESULT $? 0 0 "not display mkfs.fat"
    dosfsck -v -a /tmp/300k
    CHECK_RESULT $? 0 0 "dosfsck command execution failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /tmp/300k
    LOG_INFO "End to restore the test environment."
}
main "$@"
