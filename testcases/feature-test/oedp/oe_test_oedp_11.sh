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
# shellcheck disable=SC2016
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kubeflow-1.9.1
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kubeflow-1.9.1/config.yaml
    sed -i "s|ansible_password: \"\"|ansible_password: ${NODE1_PASSWORD}|g" ./kubeflow-1.9.1/config.yaml
    total_size=$(df -h | awk 'NR==2 {print $2}')
    fallocate -l "$total_size" /var/lib/docker/filler.img 2>/dev/null || true
    fallocate -l "$total_size" /tmp/filler.img 2>/dev/null || true
    fallocate -l "$total_size" /home/filler.img 2>/dev/null || true
    fallocate -l "$total_size" /var/tmp/filler.img 2>/dev/null || true
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p kubeflow-1.9.1 > fill_log 2>&1 
    grep "No space left on device" fill_log
    CHECK_RESULT $? 0 0 "Failed to deploying kubeflow when disk space is insufficient"
    rm -rf disk_filler.img
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
    
    rm -rf kubeflow-1.9.1 install_kubeflow_log fill_log
    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"
