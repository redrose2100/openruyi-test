#!/bin/bash
# Copyright (c), 2024-2024, Huawei Tech. Co., Ltd.
# Description: bzip2 检查压缩包完整性
# Author: sunshang <sunshang4@h-partners.com>
# Create: 2024-07-24

source  ${OET_PATH}/libs/locallibs/common_lib.sh
testfile=file_$RANDOM
set +e

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which bzip2 || yum install -y bzip2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=$testfile bs=100K count=90
    bzip2 -z $testfile
    bzip2 -t ${testfile}.bz2
    CHECK_RESULT $? 0 0 "test faild with option -t"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y bzip2" | head -n1 | awk '{print $1}')
    [ -z "$id" ] || yum history undo -y "$id"
    rm -fr ${testfile}*
    LOG_INFO "End to clean the test environment."
}

main "$@"
