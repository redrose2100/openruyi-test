#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# shellcheck disable=SC2207
# shellcheck disable=SC2202
# shellcheck disable=SC2009
# shellcheck disable=SC2022
# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   ping命令移除capabilities，普通用户执行ping
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
testuser=user"$RANDOM"
path=/usr/bin/ping

function pre_test() {
    which filecap || DNF_INSTALL "libcap-ng libcap-ng-utils"
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
    pgrep -f "user*" | awk '{print $2}' | xargs kill -9
    userdel -rf "$testuser"
    DNF_REMOVE "$@"
}

main "$@"
