#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: 验证filecap基本命令。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
testdir=testdir"$RANDOM"
testfile1=test"$RANDOM"1
testfile2=test"$RANDOM"2
path=$(pwd)/"$testdir"

function pre_test() {
    which filecap || yum install libcap-ng libcap-ng-utils -y
}

function run_test() {
    #创建一个文件夹和两个文件
    mkdir "$testdir" && touch "$testdir"/"$testfile1" "$testdir"/"$testfile2"
    CHECK_RESULT $? 0 0
    #给文件添加capabilities
    filecap "$path"/"$testfile1" sys_time && filecap "$path"/"$testfile2" sys_time
    CHECK_RESULT $? 0 0
    #获取文件的capabilities
    filecap "$path"/"$testfile1" | grep "sys\_time"
    CHECK_RESULT $? 0 0

    filecap "$path"/"$testfile2" | grep "sys\_time"
    CHECK_RESULT $? 0 0
    #获取testdir目录下文件的capabilities
    filecap "$path" | grep "$testfile1" && filecap "$path" | grep "$testfile1"
    CHECK_RESULT $? 0 0
    #移除文件的capabilities
    filecap "$path"/"$testfile1" none && filecap "$path"/"$testfile2" none
    CHECK_RESULT $? 0 0
    #再次获取文件的capabilities
    get_filecap=$(filecap "$path")
    test -z "$get_filecap"
}

function post_test() {
    rm -rf "$testdir"
}

main "$@"