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
# @Date      :   2021/01/11
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
    podman image history --format=json alpine | grep "created"
    CHECK_RESULT $? 0 0 'check podman image history --format=json alpine | grep "created" failed'
    podman image history --human alpine | grep "B"
    CHECK_RESULT $? 0 0 'check podman image history --human alpine | grep "B" failed'
    podman image history --no-trunc alpine | grep "$(podman images -aq)"
    CHECK_RESULT $? 0 0 "check podman image history --no-trunc alpine failed"
    podman image history -q alpine | grep "$(podman images -aq)"
    CHECK_RESULT $? 0 0 "check podman image history -q alpine failed"
    podman image ls --filter after=alpine
    CHECK_RESULT $? 0 0 'check podman image ls --filter after=alpine failed'
    podman image ls --all | grep "alpine"
    CHECK_RESULT $? 0 0 'check podman image ls --all | grep "alpine" failed'
    podman image ls --digests | grep "DIGEST"
    CHECK_RESULT $? 0 0 'check podman image ls --digests | grep "DIGEST" failed'
    podman image ls --format json | grep "alpine"
    CHECK_RESULT $? 0 0 'check podman image ls --format json | grep "alpine" failed'
    podman image ls --no-trunc | grep "sha256"
    CHECK_RESULT $? 0 0 'check podman image ls --no-trunc | grep "sha256" failed'
    podman image ls --noheading | grep "TAG"
    CHECK_RESULT $? 1 0 'check podman image ls --noheading | grep "TAG" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
