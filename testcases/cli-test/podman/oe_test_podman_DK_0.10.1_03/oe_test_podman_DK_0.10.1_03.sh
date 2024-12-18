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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2021/01/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in docker package
# ############################################
# shellcheck disable=SC1091

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull ubi8-minimal
    podman run --name postgres -e POSTGRES_PASSWORD=secret -d ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker push ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Storing signatures"
    CHECK_RESULT $?
    docker push --authfile temp-auths/myauths.json ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $?
    test -f /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json
    CHECK_RESULT $?
    docker push --format oci ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $?
    grep "oci" /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json
    CHECK_RESULT $?
    docker push --compress ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $?
    grep "image.rootfs.diff.tar.gzip" /tmp/myimage/manifest.json
    CHECK_RESULT $?
    docker push -q ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Storing signatures"
    CHECK_RESULT $? 0 1
    docker push --remove-signatures ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Writing manifest"
    CHECK_RESULT $?
    docker push --tls-verify ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Copying blob"
    CHECK_RESULT $?
    docker push --creds postgres:screte ubi8-minimal dir:/tmp/myimage 2>&1 | grep "Writing manifest"
    CHECK_RESULT $?
    rm -rf /tmp/myimage
    docker push --cert-dir /tmp ubi8-minimal dir:/tmp/myimage
    CHECK_RESULT $?
    test -d /tmp/myimage
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf /tmp/myimage
    LOG_INFO "End to restore the test environment."
}

main "$@"
