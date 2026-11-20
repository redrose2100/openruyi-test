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
# @Date      :   2022/06/17
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of systemd
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "[Unit]
Description=Test Service A
Requires=TestB.service
[Service]
ExecStart=/usr/bin/sleep 200" >/usr/lib/systemd/system/TestA.service
    echo "[Unit]
Description=Test Service B
[Service]
ExecStart=/usr/bin/slee 200" >/usr/lib/systemd/system/TestB.service
    systemctl daemon-reload
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start TestB
    CHECK_RESULT $? 0 0 "TestB.service start success"
    # TestB 的 ExecStart 指向不存在的 /usr/bin/slee。Type=simple 下 systemctl start
    # 先返回 0，失败状态是异步记录的，原用例紧接着 grep "failed" 存在竞态。
    # 改为先有界等待进入 failed，再用 systemctl is-failed 断言状态。
    for _i in $(seq 1 20); do
        systemctl is-failed TestB >/dev/null 2>&1 && break
        sleep 0.5
    done
    systemctl is-failed TestB | grep failed
    CHECK_RESULT $? 0 0 "TestB.service is not failed"
    systemctl start TestA
    CHECK_RESULT $? 0 0 "TestA.service start failed"
    systemctl is-active TestA | grep active
    CHECK_RESULT $? 0 0 "TestA.service is not running"
    TestA_before=$(systemctl show -p ActiveEnterTimestamp --timestamp=unix TestA | cut -d= -f2)
    SLEEP_WAIT 10
    systemctl start TestB
    CHECK_RESULT $? 0 0 "TestB.service start failed"
    for _i in $(seq 1 20); do
        systemctl is-failed TestB >/dev/null 2>&1 && break
        sleep 0.5
    done
    systemctl is-failed TestB | grep failed
    CHECK_RESULT $? 0 0 "TestB.service is not failed"
    TestA_after=$(systemctl show -p ActiveEnterTimestamp --timestamp=unix TestA | cut -d= -f2)
    # 用例意图：TestB 再次失败时 TestA 不应被连累重启。原实现拿
    # `systemctl status` 输出的第 8 列做字符串匹配，列数随 systemd 版本变化，
    # 会比较到无关字段。改为比较 TestA 的 ActiveEnterTimestamp 是否保持不变。
    [ -n "${TestA_before}" ] && [ "${TestA_before}" = "${TestA_after}" ]
    CHECK_RESULT $? 0 0 "TestA.service was restarted unexpectedly"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i "s/slee/sleep/g" /usr/lib/systemd/system/TestB.service
    systemctl daemon-reload
    systemctl restart TestB
    systemctl stop TestA
    systemctl stop TestB
    rm -rf /usr/lib/systemd/system/TestA.service /usr/lib/systemd/system/TestB.service
    LOG_INFO "End to restore the test environment."
}

main "$@"
