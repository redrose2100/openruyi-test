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
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2022/10/28
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
    podman_build_id=`podman ps -a --no-trunc |grep "busybox2"|awk '{print $1}'`
    #podman exec $podman_build_id /tmp/test_01.sh & 

    CHECK_RESULT $?
    LOG_INFO "Finish preparing the test environment.podman container is begining!"
}

function run_test() {
    LOG_INFO "Start to run test the value --help."
    conmon --help |grep "conmon \[OPTION?\]"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --version"
    conmon --version|grep "conmon version"
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -c"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -n"
    conmon -c $podman_build_id  -u $podman_build_id -n busybox2  --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -i"
    conmon -c $podman_build_id  -u $podman_build_id -n busybox2  --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log -i
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -u"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value --runtime" 
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -l"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?
    ls -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log
    CHECK_RESULT $?

    LOG_INFO "Start to run test the value -p"
    conmon -c $podman_build_id  -u $podman_build_id --runtime /usr/local/bin/runc -l /var/lib/containers/storage/overlay-containers/$podman_build_id/userdata/ctr.log -p /var/run/containers/storage/overlay-containers/$podman_build_id/userdata/pidfile
    CHECK_RESULT $?
    ls -l /var/run/containers/storage/overlay-containers/$podman_build_id/userdata/pidfile
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
