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
# @Desc      :   Deployment of KubeRay and train MLP model based on FashionMNIST on KubeRay
# #############################################
# shellcheck disable=SC2016
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL oedp python3-libselinux bc
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kuberay
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kuberay/config.yaml
    sed -i "s#ansible_password: \"\"#ansible_password: ${NODE1_PASSWORD}#g" ./kuberay/config.yaml
    sed -i '/^[[:space:]]*head:/,/^[[:space:]]*worker:/s/cpu: "[0-9]*"/cpu: "7"/' ./kuberay/config.yaml
    sed -i '/^[[:space:]]*head:/,/^[[:space:]]*worker:/s/memory: "[0-9]*G"/memory: "14G"/' ./kuberay/config.yaml
    sed -i '/^[[:space:]]*worker:/,/^[[:space:]]*[^[:space:]#]/s/num: [0-9]*/num: 0/' ./kuberay/config.yaml
    if [ "${NODE1_FRAME}" = "aarch64" ]; then
	    sed -i 's#tag: 2.9.0#tag: 2.9.0-aarch64#g' ./kuberay/config.yaml
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p kuberay 2>&1 | grep "Execute succeeded: install KubeRay"
    CHECK_RESULT $? 0 0 "Failed to install KubeRay"

    oedp run train -p kuberay > singlepod.txt 2>&1
    singlepod_time=$(grep -oP "'time_total_s':\s*\K[0-9.]+" singlepod.txt)
    grep "Execute succeeded: train MLP model based on FashionMNIST on KubeRay" singlepod.txt
    CHECK_RESULT $? 0 0 "Failed to train MLP model based on FashionMNIST on KubeRay"

    oedp run uninstall -p kuberay 2>&1 | grep "Execute succeeded: uninstall KubeRay"
    CHECK_RESULT $? 0 0 "Failed to uninstall KubeRay"

    sed -i '/^[[:space:]]*worker:/,/^[[:space:]]*[^[:space:]#]/s/num: [0-9]*/num: 2/' ./kuberay/config.yaml
    sed -i '/worker:/,/^[^[:space:]]/s/memory: "[0-9]*G"/memory: "10G"/' ./kuberay/config.yaml
    sed -i '/worker:/,/^[^[:space:]]/s/cpu: "[0-9]*"/cpu: "5"/' ./kuberay/config.yaml

    oedp run install -p kuberay 2>&1 | grep "Execute succeeded: install KubeRay"
    CHECK_RESULT $? 0 0 "Failed to install KubeRay"
    
    oedp run train -p kuberay > mulpod.txt 2>&1
    mulpod_time=$(grep -oP "'time_total_s':\s*\K[0-9.]+" mulpod.txt)
    grep "Execute succeeded: train MLP model based on FashionMNIST on KubeRay" mulpod.txt
    CHECK_RESULT $? 0 0 "Failed to train MLP model based on FashionMNIST on KubeRay"

    test "$(echo "$singlepod_time > $mulpod_time" | bc)" -eq 1
    CHECK_RESULT $? 0 0 "Failed to verify that $singlepod_time is greater than $mulpod_time"

    oedp run uninstall -p kuberay 2>&1 | grep "Execute succeeded: uninstall KubeRay"
    CHECK_RESULT $? 0 0 "Failed to uninstall KubeRay"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    rm -rf singlepod.txt mulpod.txt kuberay
    DNF_remove "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"

