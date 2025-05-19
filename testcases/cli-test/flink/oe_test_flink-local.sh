#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2022-04-22
# @License   :   Mulan PSL v2
# @Desc      :   package flink-local test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "flink"
    systemctl stop firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /opt/apache-flink*/ || exit
    ./bin/start-cluster.sh
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        wget --no-check-certificate https://repo1.maven.org/maven2/org/apache/flink/flink-runtime-web/1.17.1/flink-runtime-web-1.17.1.jar -P /opt/apache-flink*/lib/
        FLINK_ENV_JAVA_OPTS="-Xmx4G" ./bin/start-cluster.sh
    else
        ./bin/start-cluster.sh
    fi
    CHECK_RESULT $? 0 0 "Execution completion failed"
    SLEEP_WAIT 2
    ./bin/flink run examples/streaming/WordCount.jar
    CHECK_RESULT $? 0 0 "Failed to submit homework"
    tail log/flink-*-taskexecutor-*.out
    CHECK_RESULT $? 0 0 "View the returned results and report an error"
    curl http://localhost:8081 | grep "LICENSE-2.0"
    CHECK_RESULT $? 0 0 "curl http://localhost:8081 | grep \"LICENSE-2.0\""
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl start firewalld
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
