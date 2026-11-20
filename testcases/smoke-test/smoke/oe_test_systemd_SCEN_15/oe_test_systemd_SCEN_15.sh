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
ExecStart=/usr/bin/slee 200" >/usr/lib/systemd/system/TestA.service
    echo "[Unit]
Description=Test Service B
[Service]
ExecStart=/usr/bin/sleep 200" >/usr/lib/systemd/system/TestB.service
    systemctl daemon-reload
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start TestA
    CHECK_RESULT $? 0 0 "TestA.service start success"
    # TestA 的 ExecStart 指向不存在的 /usr/bin/slee。Type=simple 下 systemctl start
    # 先返回 0，失败状态是异步记录的，原用例紧接着 grep "failed" 存在竞态。
    # 改为先有界等待进入 failed，再用 is-failed 断言。
    for _i in $(seq 1 20); do
        systemctl is-failed TestA >/dev/null 2>&1 && break
        sleep 0.5
    done
    systemctl is-failed TestA | grep failed
    CHECK_RESULT $? 0 0 "TestA.service is not failed"
    systemctl start TestB
    CHECK_RESULT $? 0 0 "TestB.service start failed"
    systemctl is-active TestB | grep active
    CHECK_RESULT $? 0 0 "TestB.service is not running"
    systemctl restart TestB
    CHECK_RESULT $? 0 0 "TestB.service restart failed"
    systemctl is-failed TestA | grep failed
    CHECK_RESULT $? 0 0 "TestA.service is still not failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i "s/slee/sleep/g" /usr/lib/systemd/system/TestA.service
    systemctl daemon-reload
    systemctl restart TestA
    systemctl stop TestA
    systemctl stop TestB
    rm -rf /usr/lib/systemd/system/TestA.service /usr/lib/systemd/system/TestB.service
    LOG_INFO "End to restore the test environment."
}

main "$@"
