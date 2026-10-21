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
# @Desc      :   runc container lifecycle test with command arguments
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/runc/common.sh"

TEST_BUNDLE="/tmp/runc_lifecycle_test"
CONTAINER_ID="testcontainer"
LOG_FILE="/tmp/runc_test.log"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "runc"
    prepare_rootfs "$TEST_BUNDLE"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    runc --version | grep -qE "runc version [0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "runc --version failed"
    runc -v | grep -qE "runc version [0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "runc -v failed"
    runc --help | grep -q "USAGE"
    CHECK_RESULT $? 0 0 "runc --help failed"
    runc -h | grep -q "USAGE"
    CHECK_RESULT $? 0 0 "runc -h failed"
    # spec 生成默认配置文件
    runc spec
    CHECK_RESULT $? 0 0 "runc spec failed"
    grep -q "\"ociVersion\"" config.json
    CHECK_RESULT $? 0 0 "config.json doesn't contain ociVersion"
    # spec --rootless 生成rootless配置
    rm -f config.json
    runc spec --rootless
    CHECK_RESULT $? 0 0 "runc spec --rootless failed"
    grep -q "\"type\": \"user\"" config.json
    CHECK_RESULT $? 0 0 "rootless config.json doesn't contain user namespace"
    # spec -b 指定bundle路径
    rm -f config.json
    runc spec -b "$TEST_BUNDLE"
    CHECK_RESULT $? 0 0 "runc spec -b failed"
    [ -f "config.json" ]
    CHECK_RESULT $? 0 0 "config.json not created with -b"
    # 修改配置为非终端模式，运行sleep命令
    python3 -c "import json; d=json.load(open('config.json')); d['process']['terminal']=False; d['process']['args']=['sleep', '60']; json.dump(d, open('config.json','w'), indent=4)"
    # create 创建容器（不启动）
    runc create "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc create failed"
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"created\""
    CHECK_RESULT $? 0 0 "Container is not in created state"
    # start 启动已创建的容器
    runc start "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc start failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container is not running after start"
    # kill 发送信号停止容器
    runc kill "$CONTAINER_ID" KILL
    CHECK_RESULT $? 0 0 "runc kill failed"
    SLEEP_WAIT 3
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"stopped\""
    CHECK_RESULT $? 0 0 "Container is not stopped after kill"
    # delete -f 强制删除容器
    runc delete -f "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc delete failed"
    SLEEP_WAIT 1
    runc list 2>/dev/null | grep -q "$CONTAINER_ID"
    CHECK_RESULT $? 1 0 "Container still exists after delete"
    # --debug 启用调试日志运行容器
    runc --debug run -d "$CONTAINER_ID" 2>&1 | grep -q "debug"
    CHECK_RESULT $? 0 0 "runc --debug run failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container with --debug is not running"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # 参数组合：--log+--log-format json 指定JSON日志格式
    rm -f "$LOG_FILE"
    runc --log "$LOG_FILE" --log-format json --debug run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --log-format json failed"
    SLEEP_WAIT 2
    grep -q "^{" "$LOG_FILE"
    CHECK_RESULT $? 0 0 "Log file is not in JSON format"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # 参数组合：--log+--log-format text 指定text日志格式
    rm -f "$LOG_FILE"
    runc --log "$LOG_FILE" --log-format text --debug run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --log-format text failed"
    SLEEP_WAIT 2
    grep -q "level=" "$LOG_FILE"
    CHECK_RESULT $? 0 0 "Log file is not in text format"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # --systemd-cgroup 启用systemd cgroup支持
    runc --systemd-cgroup run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --systemd-cgroup run failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container with --systemd-cgroup is not running"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # --rootless=true 指定rootless模式运行容器
    runc spec --rootless
    python3 -c "import json; d=json.load(open('config.json')); d['process']['terminal']=False; d['process']['args']=['sleep', '60']; json.dump(d, open('config.json','w'), indent=4)"
    runc --rootless=true run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --rootless=true run failed"
    SLEEP_WAIT 2
    runc --rootless=true state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container with --rootless=true is not running"
    runc --rootless=true delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # 恢复默认配置
    runc spec
    python3 -c "import json; d=json.load(open('config.json')); d['process']['terminal']=False; d['process']['args']=['sleep', '60']; json.dump(d, open('config.json','w'), indent=4)"
    # run -b 指定bundle路径运行容器
    runc run -b "$TEST_BUNDLE" -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc run -b failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container with -b is not running"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1
    # run --keep 容器退出后不删除
    python3 -c "import json; d=json.load(open('config.json')); d['process']['args']=['echo', 'test']; json.dump(d, open('config.json','w'), indent=4)"
    runc run --keep "$CONTAINER_ID" | grep -q "test"
    CHECK_RESULT $? 0 0 "runc run --keep failed"
    runc list | grep -q "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "Container not kept after exit"
    runc delete "$CONTAINER_ID"
    SLEEP_WAIT 1
    # 恢复配置
    python3 -c "import json; d=json.load(open('config.json')); d['process']['args']=['sleep', '60']; json.dump(d, open('config.json','w'), indent=4)"
    # run --pid-file 指定pid文件运行容器
    rm -f /tmp/runc.pid
    runc run -d --pid-file /tmp/runc.pid "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc run --pid-file failed"
    SLEEP_WAIT 2
    [ -f /tmp/runc.pid ]
    CHECK_RESULT $? 0 0 "PID file not created"
    grep -q "^[0-9]\+$" /tmp/runc.pid
    CHECK_RESULT $? 0 0 "PID file content is not a valid PID"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    cleanup_container "$CONTAINER_ID"
    rm -rf "$TEST_BUNDLE" /tmp/custom_runc_root "$LOG_FILE" /tmp/runc.pid
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
