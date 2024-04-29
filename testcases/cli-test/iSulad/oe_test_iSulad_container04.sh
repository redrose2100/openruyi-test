#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# ##############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Log and Process Query
# ##############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iSulad
    cp /etc/isulad/daemon.json /etc/isulad/daemon.json.bak
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        sed -i "/registry-mirrors/a\\\"https:\\/\\/docker.io\\\"" /etc/isulad/daemon.json
    else        
        sed -i "/registry-mirrors/a\\\"https:\\/\\/ariq8blp.mirror.aliyuncs.com\\\"" /etc/isulad/daemon.json
    fi
    systemctl restart isulad.service
    isula pull busybox
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula run -itd busybox /bin/sh -c "while true;do echo hello world;sleep 1;done"
    container_id=$(isula ps -a | grep -vi NAMES | awk '{print $NF}')
    isula inspect -f "{{.State.Status}}" "$container_id" |grep -i running
    CHECK_RESULT $? 0 0 "Container startup failed"
    isula logs "$container_id" |grep -i "hello world"
    CHECK_RESULT $? 0 0 "Failed to query logs"
    isula top "$container_id"
    CHECK_RESULT $? 0 0 "Process does not exist"
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