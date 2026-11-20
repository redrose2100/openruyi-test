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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   cgroup
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to pre test."
    DNF_INSTALL "procps"
    echo "#!/bin/bash
while true
do
    sleep 1
done" >testcgroup.sh
    sh testcgroup.sh &
    pid=$!
    # cgroup v1 使用 /sys/fs/cgroup/memory；cgroup v2 使用 /sys/fs/cgroup 统一层级，
    # 动态探测可用路径，避免在 v2 系统上 mkdir 失败。
    if [ -d /sys/fs/cgroup/memory ]; then
        CGROUP_DIR=/sys/fs/cgroup/memory/example
    else
        CGROUP_DIR=/sys/fs/cgroup/example
    fi
    mkdir -p "$CGROUP_DIR"
    LOG_INFO "Start to pre test."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    if [ -d /sys/fs/cgroup/memory ]; then
        echo 1000000 >"$CGROUP_DIR"/memory.limit_in_bytes
    else
        echo 1000000 >"$CGROUP_DIR"/memory.max
    fi
    CHECK_RESULT $?
    echo ${pid} >"$CGROUP_DIR"/cgroup.procs
    CHECK_RESULT $?
    ps -o cgroup ${pid} | grep devices | grep pids
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    kill -9 ${pid}
    rmdir "$CGROUP_DIR" 2>/dev/null
    rm -rf testcgroup.sh
    LOG_INFO "Finish environment cleanup."
}

main $@
