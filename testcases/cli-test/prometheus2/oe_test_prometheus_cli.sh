#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/1/5 
# @License   :   Mulan PSL v2
# @Desc      :   Test prometheus command line
# #############################################

source "./common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    clear_env
    DNF_INSTALL prometheus2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {

    LOG_INFO "Start testing..."
    if ! IS_FREE_PORT 9090; then
        LOG_WARN "prometheus default bind port 9090 is not available!"
        LOG_WARN "Please free the port 9090 for prometheus."
        exit 126
    fi
    prometheus --version
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    prometheus --help
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    start_process --config.file="prometheus.yml"
    wait_for_ready
    curl -s "localhost:9090/config" | grep 'job_name: test_prometheus_cli'
    CHECK_RESULT $? 0 0 "Failed to use specific config file."
    clear_env
    free_port="$(GET_FREE_PORT localhost)"
    start_process --web.listen-address="0.0.0.0:$free_port"
    wait_for_ready
    curl -s "http://localhost:$free_port" | grep 'Found'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.listen-address'
    clear_env
    start_process --web.read-timeout=5m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.read-timeout'
    clear_env
    start_process --web.max-connections=100
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.max-connections'
    clear_env
    start_process --web.external-url="the_external_url"
    wait_for_ready
    curl -s 'http://localhost:9090' | grep '<a href="/the_external_url">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.external-url'
    clear_env
    start_process --web.route-prefix="the_prefix"
    wait_for_ready
    curl -s 'http://localhost:9090' | grep '<a href="/the_prefix">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.route-prefix'
    clear_env
    start_process --web.user-assets=./
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.user-assets'
    clear_env
    start_process --web.enable-lifecycle
    wait_for_ready
    curl -s -X POST 'http://localhost:9090/-/quit'
    CHECK_RESULT "$(pgrep 'prometheus')" 1 0 'Failed to use flag: --web.enable-lifecycle'
    clear_env
    start_process --web.enable-admin-api
    wait_for_ready
    curl -s -X POST 'http://localhost:9090/api/v1/admin/tsdb/snapshot' | grep '"status":"success"'
    CHECK_RESULT $? 0 0 'Failed to use flag:  --web.enable-admin-api'
    clear_env
    start_process --web.console.templates=./
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.console.templates'
    clear_env
    start_process --web.console.libraries=./
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.console.libraries'
    clear_env
    start_process --web.page-title="the title"
    wait_for_ready
    curl -s 'http://localhost:9090/config' | grep '<title>the title</title>'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.page-title'
    clear_env
    start_process --web.cors.origin=".*"
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.cors.origin'
    clear_env
    start_process --storage.tsdb.path="./the_data/"
    wait_for_ready
    CHECK_RESULT "$(ls ./the_data | grep -cE 'chunks_head|lock|queries.active|wal')" 4 0 'Failed to use flag: --storage.tsdb.path'
    clear_env
    start_process --storage.tsdb.retention=1m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention'
    clear_env
    start_process --storage.tsdb.retention.time=1m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention.time'
    clear_env
    start_process --storage.tsdb.retention.size=1MB
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention.size'
    clear_env
    start_process --storage.tsdb.no-lockfile
    wait_for_ready
    CHECK_RESULT "$(ls ./data | grep -cE 'lock')" 0 0 'Failed to use flag: --storage.tsdb.no-lockfile'
    clear_env
    start_process --storage.tsdb.allow-overlapping-blocks
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.allow-overlapping-blocks'
    clear_env
    start_process --storage.tsdb.wal-compression
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.wal-compression'
    clear_env
    start_process --storage.remote.flush-deadline=1m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.remote.flush-deadline'
    clear_env
    start_process --storage.remote.read-sample-limit=5
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.remote.read-sample-limit'
    clear_env
    start_process --storage.remote.read-concurrent-limit=5
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.remote.read-concurrent-limit'
    clear_env
    start_process --storage.remote.read-max-bytes-in-frame=100
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.remote.read-max-bytes-in-frame'
    clear_env
    start_process --rules.alert.for-outage-tolerance=1h
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --rules.alert.for-outage-tolerance'
    clear_env
    start_process --rules.alert.for-grace-period=5m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --rules.alert.for-grace-period'
    clear_env
    start_process --rules.alert.resend-delay=5m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --rules.alert.resend-delay'
    clear_env
    start_process --alertmanager.notification-queue-capacity=100
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --alertmanager.notification-queue-capacity'
    clear_env
    start_process --alertmanager.timeout=5s
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --alertmanager.timeout'
    clear_env
    start_process --query.lookback-delta=2m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --query.lookback-delta'
    clear_env
    start_process --query.timeout=2m
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --query.timeout'
    clear_env
    start_process --query.max-concurrency=10
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --query.max-concurrency'
    clear_env
    start_process --query.max-samples=100
    wait_for_ready
    CHECK_RESULT $? 0 0 'Failed to use flag: --query.max-samples'
    clear_env
    start_process --log.level=debug
    wait_for_ready
    grep 'debug' ./log
    CHECK_RESULT $? 0 0 'Failed to use flag: --log.level'
    clear_env
    start_process --log.format=json
    wait_for_ready
    grep '"level":"info","msg":"Server is ready to receive web requests."' ./log
    CHECK_RESULT $? 0 0 'Failed to use flag: --log.format'
    clear_env


    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    clear_env
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
