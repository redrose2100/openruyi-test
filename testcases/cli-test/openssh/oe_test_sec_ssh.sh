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
# @Author    :   wangxiaoya
# @Contact   :   wangxiaoya@qq.com
# @Date      :   2022/05/06
# @License   :   Mulan PSL v2
# @Desc      :   Network security configuration
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "setroubleshoot-server firewalld"
    setenforce 1  #如果在内核层禁用了selinux,那么这里是无法打开的
    selinux_status=$(getenforce)
    if [ "${selinux_status}" == "Disabled" ]; then
        LOG_WARN "Testing cannot be performed if selinux cannot be enabled."
        exit 255
    fi
    systemctl start firewalld
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep "^PasswordAuthentication yes" /etc/ssh/sshd_config
    CHECK_RESULT $?
    semanage port -a -t ssh_port_t -p tcp 36
    CHECK_RESULT $?
    semanage port --delete -t ssh_port_t -p tcp 36
    CHECK_RESULT $?
    firewall-cmd --remove-port 36/tcp
    CHECK_RESULT $?
    firewall-cmd --add-port 36/tcp
    CHECK_RESULT $?
    firewall-cmd --runtime-to-permanent
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    firewall-cmd --remove-port 36/tcp
    semanage port --delete -t ssh_port_t -p tcp 36
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
