#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: 单文件并发测试
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
testfile=file"$RANDOM"
path=$(pwd)/"$testfile"

function pre_test() {
    which filecap || yum install libcap-ng libcap-ng-utils -y
    touch "$testfile"
}

function run_test() {
    for i in $(seq 10000); do
        {
            filecap "$path" sys_time
            filecap "$path" none
        } &
    done
    wait

    filecap "$path" sys_time
    CHECK_RESULT $? 0 0
    filecap "$path" | grep "sys\_time"
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -rf "$testfile"
}

main "$@"