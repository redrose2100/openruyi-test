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
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull registry.access.redhat.com/ubi8-minimal
    podman run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman stop postgres
    podman logs -f $(podman ps -aq) 
    CHECK_RESULT $?
    podman logs -l 
    CHECK_RESULT $?
    podman logs --since 2020-12-31 $(podman ps -aq)
    CHECK_RESULT $?
    podman logs --tail 10 $(podman ps -aq) 
    CHECK_RESULT $?
    podman logs -t $(podman ps -aq) 
    CHECK_RESULT $?
    podman start postgres
    podman save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal
    podman import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported
    CHECK_RESULT $?
    cat alpine.tar | podman import -q --message "importing the alpine.tar tarball" - image-imported
    CHECK_RESULT $?
    podman export -o redis-container.tar $(podman ps -aq)
    CHECK_RESULT $?
    test -f redis-container.tar
    CHECK_RESULT $?
    podman tag $(podman images -q) test && podman images | grep test
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    podman rmi test
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
