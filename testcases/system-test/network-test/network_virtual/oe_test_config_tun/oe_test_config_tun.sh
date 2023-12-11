#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Create tap service to start
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    frame="aarch64"
    [[ ${NODE1_FRAME} -eq ${frame} ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    cp ./config_tap.sh /etc/init.d/config_tap && chmod 777 /etc/init.d/config_tap
    wget http://li.nux.ro/download/nux/misc/el7/x86_64/tunctl-1.5-12.el7.nux.x86_64.rpm
    dnf install tunctl-1.5-12.el7.nux.x86_64.rpm -y
    DNF_INSTALL "net-tools"
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    chkconfig --add config_tap
    CHECK_RESULT $? 0 0 "Add server config_tap failed."
    chkconfig --level 345 config_tap on
    CHECK_RESULT $? 0 0 "Set auto start config_tap failed."
    systemctl start config_tap
    CHECK_RESULT $? 0 0 "Start config_tap failed."
    systemctl status config_tap | grep -q "active"
    CHECK_RESULT $? 0 0 "Check config_tap start failed."
    systemctl restart config_tap
    CHECK_RESULT $? 0 0 "Restart config_tap failed."
    systemctl status config_tap | grep -q "active"
    CHECK_RESULT $? 0 0 "Check config_tap restart failed."
    systemctl stop config_tap
    CHECK_RESULT $? 0 0 "Stop config_tap failed."
    systemctl status config_tap | grep -q "inactive"
    CHECK_RESULT $? 0 0 "Check config_tap stop failed."
    chkconfig --del config_tap
    CHECK_RESULT $? 0 0 "Delete server config_tap failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ip tuntap del dev tap0 mod tap
    rm -f /etc/init.d/config_tap tunctl-1.5-12.el7.nux.x86_64.rpm
    DNF_REMOVE "$@"
    dnf remove tunctl -y
    LOG_INFO "End to restore the test environment."
}

main "$@"
