#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the registry.access.redhat.com/ubi8-minimals and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@foxmail.com
# @Date      :   2022.10.20
# @License   :   Mulan PSL v2
# @Desc      :   podman-search
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    cp ../common/test.json .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman search --limit 5 registry.access.redhat.com/ubi8-minimal | wc -l | grep 6
    CHECK_RESULT $? 0 0 'check podman search --limit 5 registry.access.redhat.com/ubi8-minimal | wc -l | grep 6 failed'
    podman search --no-trunc registry.access.redhat.com/ubi8-minimal | grep "ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman search --no-trunc registry.access.redhat.com/ubi8-minimal | grep "dockerpull.org" failed'
    podman search --authfile test.json registry.access.redhat.com/ubi8-minimal | grep -i "DESCRIPTION"
    CHECK_RESULT $? 0 0 'check podman search --authfile test.json registry.access.redhat.com/ubi8-minimal | grep -i "DESCRIPTION" failed'
    podman search --format json registry.access.redhat.com/ubi8-minimal | grep "}"
    CHECK_RESULT $? 0 0 'check podman search --format json failed'
    podman search --tls-verify=true registry.access.redhat.com/ubi8-minimal | grep -i "ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman search --tls-verify true failed'
    podman pull registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman pull registry.access.redhat.com/ubi8-minimal failed'
    id=$(podman create --name postgres -t registry.access.redhat.com/ubi8-minimal | sed -n '$p')
    test -z "${id}"
    CHECK_RESULT $? 1 0 'check id failed'
    podman start postgres | grep postgres
    CHECK_RESULT $? 0 0 'check podman start postgres | grep postgres failed'
    podman ps -a | grep postgres | grep Up
    CHECK_RESULT $? 0 0 'check podman ps -a | grep postgres failed'
    podman stats -a --no-stream
    CHECK_RESULT $? 0 0 'check podman stats -a --no-stream failed'
    podman stats --no-stream "${id}" | grep postgres
    CHECK_RESULT $? 0 0 "check podman stats --no-stream ${id} | grep postgres failed"
    podman stats --no-stream --format=json "${id}" | grep postgres
    CHECK_RESULT $? 0 0 "check podman stats --no-stream --format=json ${id} | grep postgres failed"
    podman stats --no-stream --format "table {{.ID}} {{.Name}} {{.MemUsage}}" | grep postgres
    CHECK_RESULT $? 0 0 'check podman stats --no-stream --format failed'
    podman stop postgres
    CHECK_RESULT $? 0 0 'check odman stop postgres | grep postgres failed'
    podman ps -a | grep postgres | grep Exited
    podman rm "${id}"
    CHECK_RESULT $? 0 0 "check podman rm ${id} failed"
    podman search --limit 3 registry.access.redhat.com/ubi8-minimal 2>&1 | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman search --limit 3 fedora 2>&1 | grep "dockerpull.org/library/fedora" failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.json
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
