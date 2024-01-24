#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   shidongdong
# @Contact   :   1220713556@qq.com
# @Date      :   2023/02/01
# @License   :   Mulan PSL v2
# @Desc      :   Test etmemd reliability function
# #############################################

source "../etmem_common/common_function.sh"

function change_task_file_and_add_task() {
    process_name=$1
    change_config_file_param project slide_test ./config_slide_task.yaml
    processpid=$(systemctl status "${process_name}" | grep -v grep | grep "Main PID:" | awk '{print $3}')
    change_config_file_param name "${process_name}" ./config_slide_task.yaml
    change_config_file_param value "${processpid}" ./config_slide_task.yaml

    etmem_add_slide_task ./config_slide_task.yaml test_socket
}

function pre_test() {
    LOG_INFO "config_etmem_env"
    config_etmem_env

    # copy config file to running dir
    cp ../etmem_common/config_project.yaml ./config_project.yaml
    cp ../etmem_common/config_slide_engine.yaml ./config_slide_engine.yaml
    cp ../etmem_common/config_slide_task.yaml ./config_slide_task.yaml

    # change config file for current testcase
    change_config_file_param name slide_test ./config_project.yaml

    change_config_file_param project slide_test ./config_slide_engine.yaml
}

function run_test() {
    # pull up much etmemd process
    get_up_etmemd test_socket 0

    # check etmemd numbers
    wait_fun_start etmemd
    CHECK_RESULT $? 0 0 "pull up etmemd process"

    etmem_add_project ./config_project.yaml test_socket
    etmem_add_slide_engine ./config_slide_engine.yaml test_socket

    change_task_file_and_add_task sshd
    change_task_file_and_add_task auditd
    change_task_file_and_add_task crond
    change_task_file_and_add_task dbus

    /usr/bin/etmem project show -n slide_test -s test_socket | grep sshd
    CHECK_RESULT $? 0 0 "check sshd"

    /usr/bin/etmem project show -n slide_test -s test_socket | grep auditd
    CHECK_RESULT $? 0 0 "check auditd"

    /usr/bin/etmem project show -n slide_test -s test_socket | grep crond
    CHECK_RESULT $? 0 0 "check crond"

    /usr/bin/etmem project show -n slide_test -s test_socket | grep dbus
    CHECK_RESULT $? 0 0 "check dbus"
}

function post_test() {
    # clean env
    LOG_INFO "cleanup etmem test env"
    rm -f ./config_project.yaml ./config_slide_engine.yaml ./config_slide_task.yaml
    killall etmemd
}
main "$@"
