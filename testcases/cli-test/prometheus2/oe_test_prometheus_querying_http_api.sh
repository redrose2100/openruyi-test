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
    
    LOG_INFO "Start to check querying HTTP API."
    LOG_INFO "Start to check expression queries: instant queries."
    start_process --config.file="prometheus.yml"
    wait_for_ready
    curl -s "http://localhost:9090/api/v1/query?query=prometheus_build_info"
    CHECK_RESULT $? 0 0 "Failed to use expression queries: instant queries."
    LOG_INFO "Start to check expression queries: range queries."
    timestamp=$(date +%s)
    curl -s "http://localhost:9090/api/v1/query?query=up&time=${timestamp}"
    CHECK_RESULT $? 0 0 "Failed to use expression queries: range queries."
    clear_env


    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    clear_env
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
