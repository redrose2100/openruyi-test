#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2025/06/13
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of augeas
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL augeas
    LOG_INFO "End to prepare the test environment."
}

function ver() {
    # version to number: 2.1.0 -> 200100000
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

function run_test() {
    LOG_INFO "Start to run test."
    local version exp
    version=$(rpm -q augeas|cut -d "-" -f 2)
    exp="1.14.0"
    if [[ $(ver "$version") -ge $(ver "$exp") ]]; then
        
        augtool -s set "/files/etc/hosts/1/ipaddr" "127.0.0.2"
        CHECK_RESULT $? 0 0 "augtool failed to modify /etc/hosts."
        augtool -s set "/files/etc/hosts/1/ipaddr" "127.0.0.1"
        
        augtool -s save
        CHECK_RESULT $? 0 0 "augeas failed to save changes."
        
        augtool match "/files/etc/hosts/*/ipaddr" | grep "127.0.0.1"
        CHECK_RESULT $? 0 0 "augeas failed to match nodes in /etc/hosts."
    else
        LOG_ERROR "augeas version $version lower than $exp"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
