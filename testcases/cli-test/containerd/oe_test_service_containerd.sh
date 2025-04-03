#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/10/11
# @License   :   Mulan PSL v2
# @Desc      :   Test containerd.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL containerd
    log_time="$(date '+%Y-%m-%d %T')"
    echo '{
    "cniVersion": "0.4.0",
    "name": "mynet",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.10.0.0/16",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "gateway": "10.10.0.1"
    }
}' >/etc/cni/net.d/network.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_restart containerd.service
    test_enabled containerd.service
    journalctl --since "${log_time}" -u containerd.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|failed to initialize a tracing processor"
    CHECK_RESULT $? 0 1 "There is an error message for the log of containerd.service"
    test_reload containerd.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop containerd.service
    DNF_REMOVE "$@"
    rm -rf /etc/cni/net.d/network.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
