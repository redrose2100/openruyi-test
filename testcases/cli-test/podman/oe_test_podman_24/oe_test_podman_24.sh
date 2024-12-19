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
# @Contact   :   duanxuemin@foxmail.com
# @Date      :   2022.10.11
# @License   :   Mulan PSL v2
# @Desc      :   podman container exec top
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    podman rmi --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    id=$(podman create --name postgres -t ubi8-minimal | sed -n '$p')
    test -z "${id}"
    CHECK_RESULT $? 1 0 "check ${id} failed"
    podman container stop postgres
    CHECK_RESULT $? 0 0 'check podman container stop postgres failed'
    podman container rm postgres | grep -E "${id}|postgres"
    CHECK_RESULT $? 0 0 "check podman container rm postgres | grep ${id} failed"
    podman container ls | grep postgres
    CHECK_RESULT $? 1 0 'check podman container ls | grep postgres failed'
    podman create --name postgres1 -t ubi8-minimal
    podman container stop postgres1
    CHECK_RESULT $? 0 0 'check podman container stop postgres1 failed'
    podman container cleanup postgres1
    CHECK_RESULT $? 0 0 'check podman container cleanup postgres1 failed'
    podman create --name postgres2 -t ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman create --name postgres2 -t ubi8-minimal failed'
    podman start postgres2
    podman exec -it postgres2 ls | grep "bin"
    CHECK_RESULT $? 0 0 'check podman exec -it postgres2 ls | grep "bin" failed'
    podman exec --privileged postgres2 ls | grep "boot"
    CHECK_RESULT $? 0 0 'check podman exec --privileged postgres2 ls failed'
    podman exec --user root postgres2 ls | grep "home"
    podman stop postgres2
    CHECK_RESULT $? 0 0 'check podman stop postgres2 failed'
    podman rm postgres2 postgres1
    CHECK_RESULT $? 0 0 'check podman rm postgres2 postgres1 failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
