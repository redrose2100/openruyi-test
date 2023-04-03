#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   test cmd chrpath
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "chrpath"
    pwd=`pwd`
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /usr/bin
    ldd man | grep 'libman' | grep 'not found'
    CHECK_RESULT $? 0 1 "Failed to view the dependent original path"
    chrpath -l man | grep 'PATH=/usr/lib64/man-db'
    CHECK_RESULT $? 0 0 "Incorrect runpath"
    chrpath -r "/usr/lib64/" man
    chrpath -l man | grep 'PATH=/usr/lib64/'
    CHECK_RESULT $? 0 0 "Failed to change search path"
    chrpath -c man
    ldd man | grep 'libman' | grep 'not found'
    CHECK_RESULT $? 0 0 "Dependency path conversion failed"
    chrpath -r "/usr/lib64/man-db" man
    ldd man | grep 'libman' | grep 'not found'
    CHECK_RESULT $? 0 1 "Dependent path restore failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    chrpath -r "/usr/lib64/man-db" man
    DNF_REMOVE
    cd $pwd
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

