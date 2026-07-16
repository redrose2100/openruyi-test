#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-15
# @License   :   Mulan PSL v2
# @Desc      :   runc container management test with command arguments
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/runc/common.sh"

TEST_BUNDLE="/tmp/runc_management_test"
CONTAINER_ID="mgmtcontainer"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "runc"
    prepare_rootfs "$TEST_BUNDLE"
    runc spec
    python3 -c "import json; d=json.load(open('config.json')); d['process']['terminal']=False; d['process']['args']=['sleep', '120']; json.dump(d, open('config.json','w'), indent=4)"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # run -d 启动容器
    runc run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc run -d failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container is not running after run -d"
    # list 列出容器（默认表格格式）
    runc list | grep -q "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc list failed"
    # list -f json JSON格式列出容器
    runc list -f json
    runc list -f json | grep -q "\"id\":\"$CONTAINER_ID\""
    CHECK_RESULT $? 0 0 "runc list -f json failed"
    # list -q 仅显示容器ID
    runc list -q | grep -q "^$CONTAINER_ID$"
    CHECK_RESULT $? 0 0 "runc list -q failed"
    # state 查看容器状态
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "runc state failed"
    # ps 查看容器内进程
    runc ps "$CONTAINER_ID" | grep -q "sleep"
    CHECK_RESULT $? 0 0 "runc ps failed"
    # ps -f json JSON格式查看进程
    runc ps -f json "$CONTAINER_ID" | grep -q "^\["
    CHECK_RESULT $? 0 0 "runc ps -f json failed"
    # exec 在容器内执行命令
    runc exec "$CONTAINER_ID" echo "test" | grep -q "test"
    CHECK_RESULT $? 0 0 "runc exec failed"
    # pause 暂停容器
    runc pause "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc pause failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"paused\""
    CHECK_RESULT $? 0 0 "Container is not paused"
    # resume 恢复容器
    runc resume "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc resume failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container is not resumed"
    # kill -a 向容器内所有进程发送信号
    runc kill -a "$CONTAINER_ID" KILL
    CHECK_RESULT $? 0 0 "runc kill -a failed"
    SLEEP_WAIT 3
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"stopped\""
    CHECK_RESULT $? 0 0 "Container is not stopped after kill"
    # delete -f 强制删除容器
    runc delete -f "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc delete failed"
    SLEEP_WAIT 1
    runc list 2>/dev/null | grep -q "$CONTAINER_ID" 
    CHECK_RESULT $? 1 0 "Container still exists after delete"
    # --root 指定自定义root目录运行容器
    mkdir -p /tmp/custom_runc_root
    runc --root /tmp/custom_runc_root run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --root run failed"
    SLEEP_WAIT 2
    runc --root /tmp/custom_runc_root state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "runc --root state failed"
    # --root 指定自定义root目录查看容器
    runc --root /tmp/custom_runc_root list | grep -q "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --root list failed"
    runc --root /tmp/custom_runc_root delete -f "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --root delete failed"
    SLEEP_WAIT 1
    # --criu 指定criu路径运行容器
    CRIU_PATH=$(which criu 2>/dev/null)
    if [ -n "$CRIU_PATH" ]; then
        runc --criu "$CRIU_PATH" run -d "$CONTAINER_ID"
        CHECK_RESULT $? 0 0 "runc --criu run failed"
        SLEEP_WAIT 2
        runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
        CHECK_RESULT $? 0 0 "Container with --criu is not running"
        runc delete -f "$CONTAINER_ID"
        SLEEP_WAIT 1
    else
        LOG_INFO "criu not found, skipping --criu test"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    cleanup_container "$CONTAINER_ID"
    rm -rf "$TEST_BUNDLE" /tmp/custom_runc_root
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
