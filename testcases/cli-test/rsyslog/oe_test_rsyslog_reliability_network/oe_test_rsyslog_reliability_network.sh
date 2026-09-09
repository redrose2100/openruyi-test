#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2020-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Configure TCP forwarding, set simulated 2S network delay at the client side, and write 100 logs in a loop
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "Ensuring sch_netem module is available on ${NODE2_IPV4}..."
    SSH_CMD "
        modprobe sch_netem 2>/dev/null
        if ! lsmod | grep -q sch_netem; then
            echo 'ERROR: sch_netem module not loaded.' >&2
            exit 255
        fi
        echo 'sch_netem loaded successfully.'
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    local ret=$?
    if [ $ret -eq 255 ]; then
        LOG_WARN "sch_netem not available on ${NODE2_IPV4}, skipping this test case."
        exit 255
    elif [ $ret -ne 0 ]; then
        LOG_ERROR "${NODE2_IPV4} failed to load sch_netem module (ret=$ret). Please check kernel or install manually."
        exit 1
    fi

    DNF_INSTALL "net-tools"
    systemctl stop iptables
    cat >/etc/rsyslog.d/server.conf <<EOF
    \$ModLoad imtcp
    \$InputTCPServerRun 514
EOF
    systemctl restart rsyslog
    netstat -anpt | grep 514 | grep rsyslogd
    SSH_CMD "
    systemctl stop iptables; echo 'local6.* @@${NODE1_IPV4}' > /etc/rsyslog.d/client.conf
    systemctl restart rsyslog
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SSH_CMD "tc qdisc add dev ${NODE2_NIC} root netem delay 2s" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    time=$(date +%s%N | cut -c 9-13)
    SSH_CMD "for i in \$(seq 1 100); do logger -p local6.error 'servertest$time';done" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?

    LOG_INFO "Removing netem delay rule from ${NODE2_IPV4}..."
    for i in {1..10}; do
        SSH_CMD "tc qdisc del dev ${NODE2_NIC} root netem delay 2s" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" && { LOG_INFO "Deleted after attempt $i."; break; }
        LOG_INFO "Attempt $i failed, retry in 2s."
        sleep 2
    done
    if [ $i -gt 10 ]; then LOG_ERROR "Failed to delete after 10 attempts."; return 1; fi
    CHECK_RESULT $?

    SLEEP_WAIT 30
    CHECK_RESULT "$(grep -ac "servertest$time" /var/log/messages)" 100
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    SSH_CMD "rm -rf /etc/rsyslog.d/client.conf && systemctl restart rsyslog && systemctl start iptables" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf /etc/rsyslog.d/server.conf
    systemctl restart rsyslog
    systemctl start iptables
    LOG_INFO "End to restore the test environment."
}
main "$@"
