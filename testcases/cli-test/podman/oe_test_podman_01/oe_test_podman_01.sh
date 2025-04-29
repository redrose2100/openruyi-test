#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull alpine
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman images 2>&1 | grep "alpine"
    CHECK_RESULT $? 0 0 'check podman images 2>&1 | grep "alpine" failed'
    podman pull -q alpine | grep "$(podman images -q)"
    CHECK_RESULT $? 0 0 'check podman pull -q alpine failed'
    podman pull --tls-verify alpine | grep "$(podman images -q)"
    CHECK_RESULT $? 0 0 "check podman pull --tls-verify alpine failed"
    podman run --name postgres alpine
    CHECK_RESULT $? 0 0 'check podman run --name postgres alpine failed'
    podman images --all
    CHECK_RESULT $? 0 0 'check podman images --all failed'
    podman images --digests | grep -i "DIGEST"
    CHECK_RESULT $? 0 0 'check podman images --digests | grep -i "DIGEST" failed'
    podman images --format=json | grep -i "\"digest\":"
    CHECK_RESULT $? 0 0 'check podman images --format=json failed'
    podman images --no-trunc | grep "sha256"
    CHECK_RESULT $? 0 0 'check podman images --no-trunc failed'
    podman images --noheading | grep -i "IMAGE ID"
    CHECK_RESULT $? 0 1 'check podman images --noheading failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
