#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunshang
# @Contact   :   sunshang <sunshang4@h-partners.com>
# @Date      :   2024-07-31
# @License   :   Mulan PSL v2
# @Desc      :   bzip2 check information option
# ############################################

source  "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which bzip2 || yum install -y bzip2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    bzip2 -h > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "test faild with option -h"
    bzip2 -L
    CHECK_RESULT  $? 0 0 "test faild with option -L"
    bzip2 -V
    CHECK_RESULT  $? 0 0 "test faild with option -V"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y bzip2" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "${id}"
    LOG_INFO "End to clean the test environment."
}

main "$@"

