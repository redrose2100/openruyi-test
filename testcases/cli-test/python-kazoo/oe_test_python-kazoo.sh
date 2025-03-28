#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2023/09.05
# @License   :   Mulan PSL v2
# @Desc      :   package python-kazoo test
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-kazoo zookeeper"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sudo -u zookeeper bash /opt/zookeeper/bin/zkServer.sh start
    CHECK_RESULT $? 0 0 "ZooKeeper not enabled"
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        sleep 15
    fi
    sudo -u zookeeper bash /opt/zookeeper/bin/zkServer.sh status
    CHECK_RESULT $? 0 0 "ZooKeeper JMX is turned off by default"
    python3 common/test1.py
    CHECK_RESULT $? 0 0 "Python 3 test1. py execution error"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    kill -9 "$(pgrep -f zookeeper)"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
