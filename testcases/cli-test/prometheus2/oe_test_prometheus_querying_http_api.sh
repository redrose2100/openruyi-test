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
# @Date      :   #TODO:time
# @License   :   Mulan PSL v2
# @Desc      :   Test prometheus HTTP API
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

    LOG_INFO "Start prometheus."
    LOG_INFO "Start to check HTTP API."
    LOG_INFO "Start to check expression queries."
    LOG_INFO "Start to check expression queries: instant queries."
    start_process --config.file="prometheus.yml"
    wait_for_ready
    curl -s "http://localhost:9090/api/v1/query?query=prometheus_build_info" | grep 'success'
    CHECK_RESULT $? 0 0 "Failed to use expression queries: instant queries."

    LOG_INFO "Start to check expression queries: range queries."
    timestamp=$(date +%s)
    curl -s "http://localhost:9090/api/v1/query?query=up&time=${timestamp}" | grep 'success'
    CHECK_RESULT $? 0 0 "Failed to use expression queries: range queries."


    LOG_INFO "Start to check query metadata."
    LOG_INFO "Start querying metadata: finding series by label matchers."
    curl -s 'http://localhost:9090/api/v1/series?' --data-urlencode 'match[]=up' --data-urlencode 'match[]=process_start_time_seconds' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying metadata: finding series by label matchers."

    LOG_INFO "Start querying metadata: getting label names."
    curl "http://localhost:9090/api/v1/labels"|grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying metadata: getting label names."

    LOG_INFO "Start querying metadata: querying label values."
    curl -s 'http://localhost:9090/api/v1/label/job/values' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying metadata: querying label values."

    LOG_INFO "Start querying targets."
    curl -s 'http://localhost:9090/api/v1/targets' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying targets."

    LOG_INFO "Start querying rules."
    curl -s 'http://localhost:9090/api/v1/rules' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying rules."

    LOG_INFO "Start querying alerts."
    curl -s 'http://localhost:9090/api/v1/alerts' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying alerts."

    LOG_INFO "Start querying targets metadata."
    curl -s 'http://localhost:9090/api/v1/targets/metadata' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying targets metadata."

    LOG_INFO "Start querying metric metadata."
    curl -s 'http://localhost:9090/api/v1/metadata' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying metric metadata."

    LOG_INFO "Start querying alertmanagers."
    curl -s 'http://localhost:9090/api/v1/alertmanagers' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying alertmanagers."

    LOG_INFO "Start to check status."
    LOG_INFO "Start querying config."
    curl -s 'http://localhost:9090/api/v1/status/config' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying config."

    LOG_INFO "Start querying flags."
    curl -s 'http://localhost:9090/api/v1/status/flags' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying flags"

    LOG_INFO "Start querying runtimeinfo."
    curl -s 'http://localhost:9090/api/v1/status/runtimeinfo' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying runtimeinfo"

    LOG_INFO "Start querying buildinfo."
    curl -s 'http://localhost:9090/api/v1/status/buildinfo' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying buildinfo"

    LOG_INFO "Start querying tsdb."
    curl -s 'http://localhost:9090/api/v1/status/tsdb' | grep 'success'
    CHECK_RESULT $? 0 0 "Failed querying tsdb"

    clear_env

    start_process --web.enable-admin-api
    LOG_INFO "Start to check TSDB Admin APIs."
    LOG_INFO "Start to querying snapshot."
    curl -s -X POST 'http://localhost:9090/api/v1/admin/tsdb/snapshot' 
    CHECK_RESULT $? 0 0 "Failed querying snapshot"

    LOG_INFO "Start to delete series."
    curl -sg -XPOST 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]=up'
    CHECK_RESULT $? 0 0 "Failed to delete series."

    clean_tombstones
    LOG_INFO "Start to clean tombstones."
    curl -sg -X POST 'http://localhost:9090/api/v1/admin/tsdb/clean_tombstones'
    CHECK_RESULT $? 0 0 "Failed to clean tombstones."
    clear_env

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
