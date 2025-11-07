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
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Multiple deployments of Kubeflow 
# #############################################
# shellcheck disable=SC2016
source "${OET_PATH}/testcases/feature-test/oedp/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_oedp
    DNF_INSTALL python3-libselinux
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kubeflow-1.9.1
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kuberay/config.yaml
    sed -i "s#ansible_password: \"\"#ansible_password: ${NODE1_PASSWORD}#g" ./kuberay/config.yaml
    LOG_INFO "End to prepare the test environment."
}

function cleanup_processes() {
    LOG_INFO "Cleaning up existing processes"
    pkill -f "oedp run install" || true
    pkill -f "oedp run uninstall" || true
    SLEEP_WAIT 3
}

function run_installation_cycle() {
    local round=$1
    local install_pid=""
    local result=0
    
    LOG_INFO "=== Starting test round $round ==="
    
    LOG_INFO "Round $round - Step 1: Install Kubeflow"
    oedp run install -p kubeflow-1.9.1 >> kubeflow_install.log 2>&1 &
    install_pid=$!
    LOG_INFO "Install process started: PID=$install_pid"
    
    local wait_time=$((5 + RANDOM % 11))
    LOG_INFO "Round $round - Step 2: Wait $wait_time seconds then interrupt"
    SLEEP_WAIT $wait_time
    
    if ps -p $install_pid > /dev/null 2>&1; then
        LOG_INFO "Interrupting installation process"
        kill -INT $install_pid
        CHECK_RESULT $? 0 0 "Successfully send interrupt signal"
        SLEEP_WAIT 3
        
        if ! ps -p $install_pid > /dev/null 2>&1; then
            LOG_INFO "Install process terminated successfully after interrupt"
        else
            LOG_WARN "Install process still running, force killing"
            kill -KILL $install_pid
            SLEEP_WAIT 2
        fi
    else
        LOG_INFO "Install process already finished"
        wait $install_pid
        local exit_code=$?
        LOG_INFO "Install process exit code: $exit_code"
    fi
    
    LOG_INFO "Round $round - Step 3: Reinstall Kubeflow"
    cleanup_processes
    
    oedp run install -p kubeflow-1.9.1 >> kubeflow_install.log 2>&1 &
    install_pid=$!
    LOG_INFO "Reinstall process started: PID=$install_pid"
    
    LOG_INFO "Executing uninstall command"
    if oedp run uninstall -p kubeflow-1.9.1 >> kubeflow_install.log 2>&1; then
        LOG_INFO "Uninstall completed successfully in round $round"
        result=0
    else
        local uninstall_code=$?
        LOG_WARN "Uninstall finished with code $uninstall_code in round $round"
        result=1
    fi
    
    cleanup_processes
    SLEEP_WAIT 2
    
    LOG_INFO "=== Finished test round $round ==="
    return $result
}

function run_test() {
    LOG_INFO "Start run_test"
    
    local total_success=0
    local total_rounds=$TEST_ROUNDS
    
    for ((i=1; i<=total_rounds; i++)); do
        LOG_INFO "Starting iteration $i of $total_rounds"
        
        if run_installation_cycle "$i"; then
            LOG_INFO "Round $i completed successfully"
            ((total_success++))
        else
            LOG_WARN "Round $i had some issues"
        fi
        
        if [ "$i" -lt "$total_rounds" ]; then
            LOG_INFO "Waiting 5 seconds before next round"
            SLEEP_WAIT 5
        fi
    done
    
    LOG_INFO "Test completion summary: $total_success/$total_rounds rounds successful"
    
    test "$total_success" -eq 3 
    CHECK_RESULT $? 0 0 "Overall test passed with $total_success/$total_rounds successful rounds"
    LOG_INFO "End run_test"
}

function post_test() {
    LOG_INFO "Start post_test"
    
    cleanup_processes
    rm -rf kubeflow_install.log kubeflow-1.9.1
    DNF_REMOVE "$@"
    post_oedp

    LOG_INFO "End post_test"
}

main "$@"




