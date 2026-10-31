#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/7/17
# @License   :   Mulan PSL v2
# @Desc      :   Allow network management tasks
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^example:" /etc/passwd && userdel -rf example
    DNF_INSTALL net-tools
    # 选择业务网卡，TEST_NIC 会自动排除管理网卡 NODE1_NIC
    net_card=$(TEST_NIC 1 | awk '{print $1}')
    if [ -z "${net_card}" ]; then
        LOG_WARN "No spare network interface for acl manage net test, skip."
        exit 255
    fi
    PREPARE_DONE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd example
    passwd example <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    su - example -c "/sbin/ifconfig $net_card:1 192.168.1.1 netmask 255.255.255.0"
    CHECK_RESULT $? 0 1 "Switching example users to view network devices succeeded, but it should fail here"
    setcap cap_net_admin=eip /sbin/ifconfig
    CHECK_RESULT $? 0 0 "Failed to set cap"
    su - example -c "/sbin/ifconfig $net_card:1 192.168.1.1 netmask 255.255.255.0"
    CHECK_RESULT $? 0 0 "Failed to switch example users to view network devices"
    ip a show $net_card | grep "$net_card:1" | grep '192.168.1.1'
    CHECK_RESULT $? 0 0 "Failed to display protocol address"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # pre_test 未完成环境准备（如无业务网卡直接 skip）时无需恢复
    if [ "${PREPARE_DONE:-0}" != "1" ]; then
        LOG_WARN "Test environment was not prepared, skip restore."
        return 0
    fi
    ifconfig $net_card:1 down
    setcap -r /sbin/ifconfig
    userdel -rf example
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
