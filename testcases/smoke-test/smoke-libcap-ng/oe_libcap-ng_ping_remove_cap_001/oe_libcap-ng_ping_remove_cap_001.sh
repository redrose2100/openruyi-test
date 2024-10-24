#!/usr/bin/bash
# Copyright (c),2024-2024,Huawei Tech. Co.,Ltd.
# Description: ping命令移除capabilities，普通用户执行ping。
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
#
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e
testuser=user"$RANDOM"
path=/usr/bin/ping

function pre_test() {
    which filecap || yum install libcap-ng libcap-ng-utils -y
    useradd "$testuser"
    grep "$testuser" /etc/shadow
    CHECK_RESULT $? 0 0
    ping_default_cap=($(filecap "$path" | awk 'NR==2 {$1="";$2="";print $0}' | sed 's/ //g;s/\,/ /g'))
}

function run_test() {
    #移除ping命令capabilities
    filecap "$path" none
    result=$(filecap "$path")
    test -z  "$result"

    #切换user用户执行ping命令
    su - "$testuser" -c "ping -c1 localhost" 2>&1 | grep "Operation not permitted"
    CHECK_RESULT $? 0 0

    #root账户恢复ping命令的capabilities
    filecap "$path" "${ping_default_cap[@]}"
    CHECK_RESULT $? 0 0

    #切换user用户执行ping命令
    su - "$testuser" -c "ping -c1 localhost" | grep "1 packets transmitted*"
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -rf ping_info
    ps -aux | grep "user*" | grep -v grep | awk '{print $2}' | xargs kill -9
    userdel -rf "$testuser"
}

main "$@"