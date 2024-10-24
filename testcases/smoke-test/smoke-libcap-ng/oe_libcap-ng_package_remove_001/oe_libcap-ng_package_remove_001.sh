#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: libcap-ng卸载安装测试。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e

function pre_test() {
    rpm -q libcap-ng || yum install libcap-ng -y
}

function run_test() {
    rpm -ql libcap-ng > libcap-ng_file 2>&1
    rpm -e libcap-ng --nodeps
    while read line; do
        test -f "$line"
        CHECK_RESULT $? 0 1
    done < libcap-ng_file

    yum install libcap-ng -y
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -rf libcap-ng_file
}

main "$@"