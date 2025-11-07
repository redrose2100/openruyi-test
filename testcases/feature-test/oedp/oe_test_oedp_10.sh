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
# @Desc      :   Deployment of kubeflow-1.9.1
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
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kubeflow-1.9.1/config.yaml
    sed -i "s#ansible_password: \"\"#ansible_password: ${NODE1_PASSWORD}#g" ./kubeflow-1.9.1/config.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p kubeflow-1.9.1 > install_kubeflow_log 2>&1
    grep "Execute succeeded: install kubeflow" install_kubeflow_log
    CHECK_RESULT $? 0 0 "Failed to install kubeflow"

    elapsed_time=$(grep "Elapsed time:" install_kubeflow_log | awk -F': ' '{print $2}' | awk '{print $1}')
    total_seconds=$(echo "$elapsed_time" | awk -F: '{print ($1*3600) + ($2*60) + $3}')
    test "$(echo "$total_seconds < 600" | bc)" -eq 1
    CHECK_RESULT $? 0 0 "Failed to verify that the average deployment time of kubeflow is less than 10 minutes"

    kubectl get pod -n kubeflow --no-headers | grep -v "Running"
    CHECK_RESULT $? 1 0 "Failed to verify that the status all pods is running"

    oedp run uninstall -p kubeflow-1.9.1 2>&1 | grep "Execute succeeded: uninstall kubeflow"
    CHECK_RESULT $? 0 0 "Failed to uninstall kubeflow"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    rm -rf kubeflow-1.9.1 install_kubeflow_log
    DNF_REMOVE "$@"
    post_oedp

    LOG_INFO "End to restore the test environment."
}

main "$@"
