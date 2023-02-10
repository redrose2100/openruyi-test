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
# @Desc      :   Test etmem slide engine function
# #############################################

source "../etmem_common/common_function.sh"

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

    change_config_file_param project slide_test ./config_slide_task.yaml
    sshdpid=$(systemctl status sshd | grep -v grep | grep "Main PID:" | awk '{print $3}')
    change_config_file_param name sshd ./config_slide_task.yaml
    change_config_file_param value "${sshdpid}" ./config_slide_task.yaml
}

function run_test() {
    # pull up an etmemd process
    get_up_etmemd test_socket 0
    wait_fun_start etmemd

    # add project, engine and task for etmem
    etmem_add_project ./config_project.yaml test_socket
    etmem_add_slide_engine ./config_slide_engine.yaml test_socket
    etmem_add_slide_task ./config_slide_task.yaml test_socket
    etmem_start_project slide_test test_socket

    sleep 60
    # check slide function 
    swap_num=$(cat /proc/"${sshdpid}"/status | grep VmSwap | awk '{print $2}')
    CHECK_RESULT "${swap_num}" 0 1 "check slide function"

    # del task, engine and project
    etmem_stop_project slide_test test_socket
    etmem_del_slide_task ./config_slide_task.yaml test_socket
    etmem_del_slide_engine ./config_slide_engine.yaml test_socket
    etmem_del_project ./config_project.yaml test_socket
}

function post_test() {
    # clean env
    LOG_INFO "cleanup etmem test env"
    killall etmemd
    systemctl restart sshd
    rm -rf ./config_project.yaml ./config_slide_engine.yaml ./config_slide_task.yaml
}
main "$@"
