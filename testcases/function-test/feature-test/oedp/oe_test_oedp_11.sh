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
# @Desc      :   Deploying kubeflow when disk space is insufficient
# #############################################
# shellcheck disable=SC2016,SC1091
source "./common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_k8s
    install_helm
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kubeflow-1.9.1
    sed -i "s|ansible_host: HOST_IP|ansible_host: ${NODE1_IPV4}|g" ./kubeflow-1.9.1/config.yaml
    sed -i "s|ansible_password: \"\"|ansible_password: ${NODE1_PASSWORD}|g" ./kubeflow-1.9.1/config.yaml
    available_size=$(df -BM / | awk 'NR==2 {print $4}' | sed 's/M//')
    fill_size=$((available_size - 100))  # 留100M

    if [ $fill_size -gt 0 ]; then
        LOG_INFO "Creating filler files of ${fill_size}M to fill disk"
        fallocate -l "${fill_size}M" /var/lib/docker/filler.img
        fallocate -l "${fill_size}M" /tmp/filler.img
        fallocate -l "${fill_size}M" /home/filler.img
        fallocate -l "${fill_size}M" /var/tmp/filler.img
    fi

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p kubeflow-1.9.1  2>&1 | grep "No space left on device"
    CHECK_RESULT $? 0 0 "Failed to deploying kubeflow when disk space is insufficient"

    rm -rf /var/lib/docker/filler.img
    rm -rf /tmp/filler.img
    rm -rf /home/filler.img
    rm -rf /var/tmp/filler.img
    oedp run clean -p kubeflow-1.9.1 2>&1 | grep "Execute succeeded: clean cache files"
    CHECK_RESULT $? 0 0 "Failed to uninstall kubeflow"

    SLEEP_WAIT 60
    oedp run install -p kubeflow-1.9.1 > install_kubeflow_log 2>&1 
    grep "Execute succeeded: install kubeflow" install_kubeflow_log
    CHECK_RESULT $? 0 0 "Failed to install kubeflow"

    oedp run uninstall -p kubeflow-1.9.1 2>&1 | grep "Execute succeeded: uninstall kubeflow"
    CHECK_RESULT $? 0 0 "Failed to uninstall kubeflow"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    uninstall_helm
    uninstall_k8s
    rm -rf kubeflow-1.9.1 install_kubeflow_log helm-3.9.0 install_helm kubernetes-1.31.1 install_kubernetes 
    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"
