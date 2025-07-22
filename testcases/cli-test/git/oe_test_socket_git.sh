#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/12/29
# @License   :   Mulan PSL v2
# @Desc      :   Test git.socket restart
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL git-daemon
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution git.socket
    systemctl start git.socket
    systemctl reload git.socket 2>&1 | grep "Job type reload is not applicable for unit git.socket"
    CHECK_RESULT $?
    systemctl status git.socket | grep "Active: active"
    CHECK_RESULT $?
    
    # 新增测试参数1：测试git.socket的stop和start操作
    LOG_INFO "Testing git.socket stop and start operations"
    systemctl stop git.socket
    CHECK_RESULT $? 0 0 "Failed to stop git.socket"
    systemctl status git.socket | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "git.socket is not properly stopped"
    systemctl start git.socket
    CHECK_RESULT $? 0 0 "Failed to start git.socket"
    
    # 新增测试参数2：测试git.socket的enable和disable操作
    LOG_INFO "Testing git.socket enable and disable operations"
    systemctl enable git.socket
    CHECK_RESULT $? 0 0 "Failed to enable git.socket"
    systemctl is-enabled git.socket | grep "enabled"
    CHECK_RESULT $? 0 0 "git.socket is not properly enabled"
    systemctl disable git.socket
    CHECK_RESULT $? 0 0 "Failed to disable git.socket"
    
    # 新增测试参数3：测试git.socket的is-enabled状态检查
    LOG_INFO "Testing git.socket is-enabled status check"
    systemctl is-enabled git.socket | grep "disabled"
    CHECK_RESULT $? 0 0 "git.socket is not properly disabled"
    systemctl is-active git.socket | grep "active"
    CHECK_RESULT $? 0 0 "git.socket is not active after disable"
    
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
