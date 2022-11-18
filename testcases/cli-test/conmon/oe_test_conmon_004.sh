#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# ##################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/10/09
# @License   :   Mulan PSL v2
# @Desc      :   Test uuid command
# ##################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./conmon_podman.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env

    podman load < busybox.tar
    podman run --name busybox2 -dti docker.io/library/busybox:latest
    podman_build_id=`podman ps -a --no-trunc |grep "busybox2"|awk '{print $1}'`
    #podman exec $podman_build_id /tmp/test_01.sh & 

    CHECK_RESULT $?
    LOG_INFO "Finish preparing the test environment.podman container is begining!"
}

function run_test() {
    LOG_INFO "Start to run test the value --exit-dir"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-dir /var/run/libpod/exits
    CHECK_RESULT $?
    ls -l /var/run/libpod/exits 
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --exit-command"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-command /usr/bin/podman
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --exit-command-arg"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-command /usr/bin/podman --exit-command-arg /var/run/containers/storage
    CHECK_RESULT $?
    ls -l /var/run/containers/storage
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -T"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-command /usr/bin/podman --exit-command-arg /var/run/containers/storage -T 10
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --log-size-max"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-command /usr/bin/podman --exit-command-arg /var/run/containers/storage -T 10 --log-size-max 20480
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --socket-dir-path"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log --exit-command /usr/bin/podman --exit-command-arg /var/run/containers/storage -T 10 --log-size-max 20480 --socket-dir-path /var/run/libpod/socket
    CHECK_RESULT $?
    ls -l /var/run/libpod/socket/
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --syslog"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log  --syslog /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/sys.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --log-level"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log  --syslog /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/sys.log --log-level error
    CHECK_RESULT $?

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    podman stop busybox2 
    podman ps -a|grep busybox:latest|awk {'print $1'}|xargs podman rm
    podman rmi docker.io/library/busybox 
    clear_env
    DNF_REMOVE

    rm -rf attach ctl 
    rm -rf uuid_file
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
