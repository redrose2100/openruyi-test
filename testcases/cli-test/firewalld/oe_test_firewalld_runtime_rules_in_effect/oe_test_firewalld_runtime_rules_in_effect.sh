#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2022-12-11
#@License       :   Mulan PSL v2
#@Desc          :   Runtime firewalld rules in effect
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "Start firewalld on node 2"

    # Origin status of firewalld
    origin="enable"
    P_SSH_CMD --node 2 --cmd "firewall-cmd --state" || {
	    P_SSH_CMD --node 2 --cmd "systemctl enable firewalld --now"
            origin="disable"
    }

    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "firewall-cmd --state"
    CHECK_RESULT "$?" 0 0 "firewalld not running. Start failed?" 1

    RichRule='rule family="ipv6" port port="11" protocol="tcp" mark set=11/11'
    LOG_INFO "test rule: $RichRule"

    # check non-exists
    P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" | grep "$RichRule"
    CHECK_RESULT "$?" 0 1 "rich rule already exists, test exit." 1

    # add rule
    P_SSH_CMD --node 2 --cmd "firewall-cmd --add-rich-rule='${RichRule}'"
    CHECK_RESULT "$?" 0 0 "add rich rule failed."

    # check exists
    P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" | grep "$RichRule"
    CHECK_RESULT "$?" 0 0 "rich rule not exists, add failed?" 1

    # remove
    P_SSH_CMD --node 2 --cmd "firewall-cmd --remove-rich-rule='${RichRule}'"
    CHECK_RESULT "$?" 0 0 "remove rich rule failed."

    # check non-exists
    P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" | grep "$RichRule"
    CHECK_RESULT "$?" 0 1 "rich rule still exists, remove failed?" 1

    # add
    P_SSH_CMD --node 2 --cmd "firewall-cmd --add-rich-rule='${RichRule}'"
    P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" | grep "$RichRule"
    CHECK_RESULT "$?" 0 0 "rich rule not exists, add failed?" 1

    REMOTE_REBOOT 2 15
    sleep 30

    # check non-exist after reboot
    P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" | grep "$RichRule"
    CHECK_RESULT "$?" 0 1 "rich rule still exists after system reboot"
    LOG_INFO "End to run test."
}

function post_test() {
    P_SSH_CMD --node 2 --cmd "systemctl $origin firewalld --now"
}

main "$@"
