#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# ##################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test conmon command 
# ##################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./conmon_podman.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman load < busybox.tar
    podman run --name busybox2 -dti docker.io/library/busybox:latest
    podman_build_id=$(podman ps -a --no-trunc |grep "busybox2"|awk '{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --runtime-opt "mkdir /tmp/test001"
    CHECK_RESULT $? 0 0 "Failed to check the --runtime-opt"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --runtime-arg "mkdir /tmp/test002"
    CHECK_RESULT $? 0 0 "Failed to check the --runtime-arg"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --restore-arg test003
    CHECK_RESULT $? 0 0 "Failed to check the --restore-arg"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --restore test004 
    CHECK_RESULT $? 0 0 "Failed to check the --restore"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exec-attach > attach 2>&1
    grep "Attach" attach
    CHECK_RESULT $? 0 0 "Failed to check the --attach"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --leave-stdin-open 1 
    CHECK_RESULT $? 0 0 "Failed to check the --leave-stdin-open"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --no-new-keyring 1 
    CHECK_RESULT $? 0 0 "Failed to check the --no-new-keyring"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --no-pivot 1 
    CHECK_RESULT $? 0 0 "Failed to check the --no-pivot"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --replace-listen-pid 22222
    CHECK_RESULT $? 0 0 "Failed to check the --replace-listen-pid"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log -b /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata 
    test -d /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata
    CHECK_RESULT $? 0 0 "Failed to check the -b"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    podman stop busybox2 
    podman ps -a|grep busybox:latest|awk {'print $1'}|xargs podman rm
    podman rmi docker.io/library/busybox 
    clear_env
    DNF_REMOVE
    rm -rf attach ctl uuid_file 
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
