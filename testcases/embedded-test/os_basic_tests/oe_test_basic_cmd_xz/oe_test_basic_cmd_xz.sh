.#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023.1.31
# @License   :   Mulan PSL v2
# @Desc      :   Xz basic function verification
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    file="test.txt"
    echo "test" >> ${file}

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    xz -z $file
    ls | grep ${file}.xz
    CHECK_RESULT $? 0 0 "xz-z compress ${file} fail"
    xz -d ${file}.xz
    ls | grep ${file}
    CHECK_RESULT $? 0 0 "xz-d decompression ${file} fail"
    xz ${file}
    ls | grep ${file}.xz
    CHECK_RESULT $? 0 0 "compress ${file}.xz fail"
    xzcat ${file}.xz | grep 'test'
    CHECK_RESULT $? 0 0 "not found ${file} in ${file}.xz"
    unxz  ${file}.xz
    ls | grep ${file}
    CHECK_RESULT $? 0 0 "unxz decompression ${file} fail"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ${file} ${file}.xz

    LOG_INFO "End to restore the test environment."
}
main $@
