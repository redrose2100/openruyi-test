#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2021/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test kubelet.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    swapoff -a
    kube_version=$(dnf info kubernetes |grep -wi version |awk '{print $NF}')
    if [[ "$(printf '%s\n' "$kube_version" "1.21" | sort -V | head -n1)" == "1.21" ]];then
        DNF_INSTALL "containerd kubernetes-kubelet conntrack-tools cri-tools"
        systemctl start containerd
        crictl config runtime-endpoint unix:///run/containerd/containerd.sock
        crictl config image-endpoint unix:///run/containerd/containerd.sock
    else
        DNF_INSTALL "docker-engine kubernetes-kubelet conntrack-tools"
        systemctl start docker
    fi
    service=kubelet.service
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_restart ${service}
    test_enabled ${service}
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING" | grep -vE "CredentialsChainVerboseErrors|Failed to read data from checkpoint"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    test_reload ${service}
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    if [[ "$(printf '%s\n' "$kube_version" "1.21" | sort -V | head -n1)" == "1.21" ]];then
        systemctl stop containerd kubelet
    else
        systemctl stop docker kubelet
    fi
    swapon -a
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
