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

source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_BUNDLE="/tmp/runc_lifecycle_test"
CONTAINER_ID="testcontainer"
LOG_FILE="/tmp/runc_test.log"

function pre_test() {
    LOG_INFO "Start environment preparation."
    if yum list 2>/dev/null | grep -q "docker-runc"; then
        DNF_INSTALL "docker-runc"
    else
        DNF_INSTALL "runc"
    fi
    mkdir -p "$TEST_BUNDLE/rootfs/bin"
    mkdir -p "$TEST_BUNDLE/rootfs/lib"
    mkdir -p "$TEST_BUNDLE/rootfs/lib64"
    mkdir -p "$TEST_BUNDLE/rootfs/usr/lib64"
    cp -a /bin/sleep "$TEST_BUNDLE/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/echo "$TEST_BUNDLE/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/sh "$TEST_BUNDLE/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/cat "$TEST_BUNDLE/rootfs/bin/" 2>/dev/null || true
    cp -a /lib/ld-linux-aarch64.so.1 "$TEST_BUNDLE/rootfs/lib/" 2>/dev/null || true
    cp -a /lib/ld-linux-x86-64.so.2 "$TEST_BUNDLE/rootfs/lib/" 2>/dev/null || true
    cp -a /lib64/ld-linux-x86-64.so.2 "$TEST_BUNDLE/rootfs/lib64/" 2>/dev/null || true
    cp -a /usr/lib64/libc.so.6 "$TEST_BUNDLE/rootfs/usr/lib64/" 2>/dev/null || true
    cp -a /usr/lib64/libc.so.6 "$TEST_BUNDLE/rootfs/lib64/" 2>/dev/null || true
    cd "$TEST_BUNDLE" || exit 1
    LOG_INFO "End of environmental preparation!"
}

function cleanup_container() {
    runc delete -f "$CONTAINER_ID" 2>/dev/null || true
    runc --root /tmp/custom_runc_root delete -f "$CONTAINER_ID" 2>/dev/null || true
}

function run_test() {
    LOG_INFO "Start to run test."

    # spec 生成默认配置文件
    runc spec
    CHECK_RESULT $? 0 0 "runc spec failed"
    cat config.json | grep -q "\"ociVersion\""
    CHECK_RESULT $? 0 0 "config.json doesn't contain ociVersion"

    # spec --rootless 生成rootless配置
    rm -f config.json
    runc spec --rootless
    CHECK_RESULT $? 0 0 "runc spec --rootless failed"
    cat config.json | grep -q "\"rootless\""
    CHECK_RESULT $? 0 0 "rootless config.json doesn't contain rootless field"

    # spec -b 指定bundle路径
    rm -f config.json
    runc spec -b "$TEST_BUNDLE"
    CHECK_RESULT $? 0 0 "runc spec -b failed"
    [ -f "config.json" ]
    CHECK_RESULT $? 0 0 "config.json not created with -b"

    # 修改配置为非终端模式，运行sleep命令
    python3 -c "import json; d=json.load(open('config.json')); d['process']['terminal']=False; d['process']['args']=['sleep', '60']; json.dump(d, open('config.json','w'), indent=4)"

    # 清理可能存在的容器
    cleanup_container
    SLEEP_WAIT 1

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
    runc kill "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc kill failed"
    SLEEP_WAIT 3
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"stopped\""
    CHECK_RESULT $? 0 0 "Container is not stopped after kill"

    # delete -f 强制删除容器
    runc delete -f "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc delete failed"
    SLEEP_WAIT 1
    runc list 2>/dev/null | grep -q "$CONTAINER_ID" || CHECK_RESULT $? 1 0 "Container still exists after delete"

    # --debug 启用调试日志运行容器
    runc --debug run -d "$CONTAINER_ID" 2>&1 | grep -q "DEBUG"
    CHECK_RESULT $? 0 0 "runc --debug run failed"
    SLEEP_WAIT 2
    runc state "$CONTAINER_ID" | grep -q "\"status\": \"running\""
    CHECK_RESULT $? 0 0 "Container with --debug is not running"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1

    # --log 指定日志文件运行容器
    rm -f "$LOG_FILE"
    runc --log "$LOG_FILE" run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --log run failed"
    SLEEP_WAIT 2
    [ -s "$LOG_FILE" ]
    CHECK_RESULT $? 0 0 "Log file not created or empty"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1

    # --log-format json 指定JSON日志格式
    rm -f "$LOG_FILE"
    runc --log "$LOG_FILE" --log-format json run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --log-format json failed"
    SLEEP_WAIT 2
    cat "$LOG_FILE" | grep -q "^{"
    CHECK_RESULT $? 0 0 "Log file is not in JSON format"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1

    # --log-format text 指定text日志格式
    rm -f "$LOG_FILE"
    runc --log "$LOG_FILE" --log-format text run -d "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "runc --log-format text failed"
    SLEEP_WAIT 2
    cat "$LOG_FILE" | grep -q "level="
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
    cat /tmp/runc.pid | grep -q "^[0-9]\+$"
    CHECK_RESULT $? 0 0 "PID file content is not a valid PID"
    runc delete -f "$CONTAINER_ID"
    SLEEP_WAIT 1

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    cleanup_container
    rm -rf "$TEST_BUNDLE"
    rm -rf /tmp/custom_runc_root
    rm -f "$LOG_FILE"
    rm -f /tmp/runc.pid
    LOG_INFO "Finish environment cleanup!"
}

main "$@"