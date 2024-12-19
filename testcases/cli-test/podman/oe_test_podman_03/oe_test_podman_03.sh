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
    echo '"auth":{}' >myauths.json
    podman pull ubi8-minimal
    podman run --name postgres -e POSTGRES_PASSWORD=secret -d ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman push ubi8-minimal dir:/tmp/myimage 2>&1 | grep "signatures"
    CHECK_RESULT $? 0 0 'check podman push ubi8-minimal dir:/tmp/myimage  failed'
    podman push --authfile myauths.json ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $? 0 0 'check podman push --authfile temp-auths/myauths.json ubi8-minimal dir:/tmp/myimage failed'
    test -f /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json
    CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
    podman push --format oci ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $? 0 0 'check podman push --format oci ubi8-minimal dir:/tmp/myimage failed'
    grep "oci" /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json
    CHECK_RESULT $? 0 0 'check grep "oci" /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
    podman push --compress ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $? 0 0 'check podman push --compress ubi8-minimal dir:/tmp/myimage failed'
    grep "image.rootfs.diff.tar.gzip" /tmp/myimage/manifest.json
    CHECK_RESULT $? 0 0 'check grep "image.rootfs.diff.tar.gzip" /tmp/myimage/manifest.json failed'
    podman push -q ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $? 0 0 'check podman push -q ubi8-minimal dir:/tmp/myimage failed'
    test -f /tmp/myimage/manifest.json
    CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json failed'
    podman push --remove-signatures ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Writing manifest"
    CHECK_RESULT $? 0 0 'check podman push --remove-signatures ubi8-minimal dir:/tmp/myimage failed'
    podman push --tls-verify ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Copying blob"
    CHECK_RESULT $? 0 0 'check podman push --tls-verify ubi8-minimal dir:/tmp/myimage failed'
    podman push --creds postgres:screte ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Writing manifest"
    CHECK_RESULT $? 0 0 'check podman push --creds postgres:screte ubi8-minimal dir:/tmp/myimage failed'
    rm -rf /tmp/myimage
    podman push --cert-dir /tmp ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $? 0 0 'check podman push --cert-dir /tmp ubi8-minimal dir:/tmp/myimage failed'
    test -d /tmp/myimage
    CHECK_RESULT $? 0 0 'check test -d /tmp/myimage failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf /tmp/myimage myauths.json
    LOG_INFO "End to restore the test environment."
}

main "$@"
