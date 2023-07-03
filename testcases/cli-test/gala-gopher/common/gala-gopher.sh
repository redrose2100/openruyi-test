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
# @Author    :   yuanlulu
# @Contact   :   1297248816@qq.com
# @Date      :   2023/07/03
# @License   :   Mulan PSL v2
# @Desc      :   gala-gopher common function
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

GOPHER_CONF_PATH="/etc/gala-gopher/gala-gopher.conf"

function start_gopher() {
    rpm -qa | grep gala-gopher || yum install -y gala-gopher
    systemctl start gala-gopher
}

function clean_gopher() {
    systemctl stop gala-gopher
    #yum remove -y gala-gopher
}

function get_unused_port() {
    local port

    for ((i = 0; i < 10; i++)); do
        port=$(echo $RANDOM)
        lsof -i:"$port" || break
    done
    echo "$port"
}

function deploy_iperf() {
    local tmp_port=${1:-5001}
    local tmp_log=${2:-~/log_iperf}

    which iperf || yum install -y iperf
    ps aux | grep iperf | awk '{print $2}' | xargs kill -9
    SSH_CMD "which iperf || yum install -y iperf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "ps aux | grep iperf | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function clean_iperf() {
    ps aux | grep iperf | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps aux | grep iperf | awk '{print \$2}' | xargs kill -9" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    which iperf || yum remove -y iperf
    SSH_CMD "which iperf || yum remove -y iperf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function is_support_rest() {
    main_process=$(systemctl status gala-gopher | grep 'Main PID' | awk '{print $3}')
    ps -T -p "$main_process" | grep PROBEMNG
    echo $?
}

function check_log() {
    cat fail_log | wc -l | grep 0
    CHECK_RESULT $? 0 0
    cat fail_log #debug
}
