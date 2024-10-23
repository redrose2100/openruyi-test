#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: captest添加capabilities，普通用户执行captest。 
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-15
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
testuser=user"$RANDOM"

function pre_test() {
    which captest || yum install libcap-ng libcap-ng-utils -y
    path=$(which captest)
    useradd "$testuser"
    captest_default_cap=$(filecap "$path")
    test -z "$captest_default_cap" 
    CHECK_RESULT $? 0 0
}

function run_test() {
    #普通用户执行captest
    su - "$testuser" -c captest | grep -E "^Current capabilities: none$"
    CHECK_RESULT $? 0 0
    su - "$testuser" -c captest | grep -E "^Child capabilities: none$"
    CHECK_RESULT $? 0 0

    #为captest命令添加chown特权
    filecap "$path" chown
    result=$(filecap "$path" | awk 'NR==2 {print $NF}')
    [[ "$result" = "chown" ]] 
    CHECK_RESULT $? 0 0 

    #普通用户再次执行captest
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Effective"
    CHECK_RESULT $? 0 0
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Permitted"
    CHECK_RESULT $? 0 0
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Inheritable"
    CHECK_RESULT $? 0 0
    su - "$testuser" -c captest | grep -E -A5 "^Child capabilities:$" | grep -E "Bounding Set"
    CHECK_RESULT $? 0 0
}

function post_test() {
    filecap "$path" none
    userdel -r "$testuser"
}

main "$@"