#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/11/29
# @License   :   Mulan PSL v2
# @Desc      :   Execute Container Command
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iSulad
    cp /etc/isulad/daemon.json /etc/isulad/daemon.json.bak
    sed -i "/registry-mirrors/a\\\"https:\\/\\/docker.m.daocloud.io\\\"" /etc/isulad/daemon.json
    systemctl restart isulad.service
    isula pull busybox
    isula create -it busybox
    container_id=$(isula ps -a | grep -vi NAMES | awk '{print $NF}')
    isula start "$container_id"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula exec -it "$container_id" /bin/sh -c "ls / | grep bin"
    CHECK_RESULT $? 0 0 "There is no such file or directory"
    isula exec -it "$container_id" /bin/sh -c "touch /tmp/test.txt"
    isula exec -it "$container_id" /bin/sh -c "ls /tmp/test.txt"
    CHECK_RESULT $? 0 0 "There is no such file or directory"
    isula exec -it "$container_id" /bin/sh -c "exit"
    CHECK_RESULT $? 0 0 "Failed to exit container"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    isula ps -a |grep -vi NAMES |awk '{print $NF}' |xargs -I {} isula stop {}
    isula ps -a |grep -vi NAMES |awk '{print $NF}' |xargs -I {} isula rm -f {}
    isula  rmi busybox
    mv -f /etc/isulad/daemon.json.bak /etc/isulad/daemon.json
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"