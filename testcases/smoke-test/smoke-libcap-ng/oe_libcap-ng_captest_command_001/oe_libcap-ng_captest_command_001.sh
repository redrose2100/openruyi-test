#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: 验证captest参数。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
text=($(capsh --print | grep "Bounding" | awk -F"=" '{print $2}' | sed 's/cap_//g;s/,/ /g'))

function pre_test() {
    which captest || yum install libcap libcap-ng libcap-ng-utils -y
}

function run_test() {
    #验证--drop-all参数
    captest --drop-all > drop_all_info 2>&1
    cat drop_all_info | grep -E "^Current capabilities: none$" && cat drop_all_info | grep -E "Child capabilities: none$"
    CHECK_RESULT $? 0 0

    #验证--drop-caps参数
    captest --drop-caps > drop_caps_info 2>&1
    cat drop_caps_info | grep -E "^Current capabilities: none$" && cat drop_caps_info | grep -E "^Child capabilities:$"
    CHECK_RESULT $? 0 0
    cat drop_caps_info | grep -E -A5 "^Child capabilities:$" | grep -E "^Effective:"
    CHECK_RESULT $? 0 0
    cat drop_caps_info | grep -E -A5 "^Child capabilities:$" | grep -E "^Permitted:"
    CHECK_RESULT $? 0 0
    cat drop_caps_info | grep -E -A5 "^Child capabilities:$" | grep -E "^Inheritable:"
    CHECK_RESULT $? 0 0
    cat drop_caps_info | grep -E -A5 "^Child capabilities:$" | grep -E "^Bounding Set:"
    CHECK_RESULT $? 0 0

    #验证--text参数
    captest --text > text_info 2>&1
    cat text_info | grep "${text[0]}"
    CHECK_RESULT $? 0 0
    cat text_info | grep "^Child Effective:"
    CHECK_RESULT $? 0 0
    cat text_info | grep "^Child Permitted:"
    CHECK_RESULT $? 0 0
    cat text_info | grep "^Child Inheritable:"
    CHECK_RESULT $? 0 0
    cat text_info | grep "^Child Bounding Set:"
    CHECK_RESULT $? 0 0

}

function post_test() {
    rm -rf drop_all_info drop_caps_info text_info
}

main "$@"