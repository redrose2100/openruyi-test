#!/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: 验证filecap参数。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
path="$PATH"
testfile=test"$RANDOM"
curr_loc=$(pwd)
location=$(pwd)/"$testfile"

function pre_test() {
    which filecap || yum install libcap libcap-ng libcap-ng-utils -y
    cat /sys/kernel/tracing/buffer_size_kb
    def_val=$(awk '{print $NF}' /sys/kernel/tracing/buffer_size_kb | cut -d ')' -f 1)
}

function run_test() {
    #创建一个文件并添加capabilities
    touch "$testfile" && filecap "$location" sys_time

    #验证-d参数
    capsh --print | grep Bounding | awk -F"=" '{print $2}' | sed 's/cap_//g;s/,/ /g' > set_info 2>&1
    filecap -d > filecap_d_info 2>&1
    for i in $(cat filecap_d_info); do
        grep -i "$i" set_info
        CHECK_RESULT $? 0 0
    done

    #验证filecap -a参数
    filecap -a > filecap_a_info 2>&1
    cat filecap_a_info | grep "$testfile" | grep "sys\_time"
    CHECK_RESULT $? 0 0

    #验证filecap命令
    filecap | grep "$testfile" | grep "sys\_time"
    CHECK_RESULT $? 1 0
    #添加到环境变量后验证filecap命令
    PATH="$PATH":$(pwd)
    filecap | grep "$testfile" | grep "sys\_time"
    CHECK_RESULT $? 0 0
}

function post_test() {
    echo "${def_val}" > /sys/kernel/tracing/buffer_size_kb
    cat /sys/kernel/tracing/buffer_size_kb
    filecap "$location" none
    rm -rf set_info filecap_d_info filecap_a_info longfile /root/testdir "$testfile"
    PATH="$path"
}

main "$@"