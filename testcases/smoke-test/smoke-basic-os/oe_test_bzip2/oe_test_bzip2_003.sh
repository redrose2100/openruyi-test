#!/bin/bash
# Copyright (c), 2022-2022, Huawei Tech. Co., Ltd.
# Description: 确认bzip2查询信息参数
# Author: sunshang <sunshang4@h-partners.com>
# Create: 2024-07-24

source  ${OET_PATH}/libs/locallibs/common_lib.sh
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
    [ -z "$id" ] || yum history undo -y "$id"
    LOG_INFO "End to clean the test environment."
}

main "$@"

