#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description:  验证netcap参数。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e

function pre_test() {
    which netcap || yum install libcap-ng libcap-ng-utils -y
}

function run_test() {
    netcap | grep -E "tcp|udp|raw|pkt"
    CHECK_RESULT $? 0 0
}

function post_test() {
    return 0
}

main "$@"