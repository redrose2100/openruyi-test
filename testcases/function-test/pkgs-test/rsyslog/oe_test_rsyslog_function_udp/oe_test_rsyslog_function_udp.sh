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
# @Desc      :   Close the firewall, support UCP protocol
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "net-tools"
    # firewalld/iptables/selinux are only changed for the duration of this run;
    # post_test restores the state recorded here.
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    ORIG_SELINUX_MODE=$(getenforce 2>/dev/null)
    IPTABLES_RULES_FILE=$(mktemp /tmp/iptables_rules.XXXXXX)
    iptables-save >"${IPTABLES_RULES_FILE}" 2>/dev/null
    systemctl stop iptables firewalld 2>/dev/null
    setenforce 0
    SSH_CMD "systemctl stop iptables" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    iptables -F INPUT && iptables -P INPUT ACCEPT
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat >/etc/rsyslog.d/server.conf <<EOF
    \$ModLoad imudp
    \$UDPServerRun 514
EOF
    systemctl restart rsyslog
    CHECK_RESULT $?
    netstat -anpu | grep 514 | grep rsyslogd
    CHECK_RESULT $?
    time=$(date +%s%N | cut -c 9-13)
    SSH_CMD "
    echo  'local6.* @${NODE1_IPV4}' > /etc/rsyslog.d/client.conf
    systemctl restart rsyslog
    logger -t udp -p local6.err 'udptest${time}'
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    SLEEP_WAIT 10
    grep "udptest$time" /var/log/messages
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    SSH_CMD "rm -rf /etc/rsyslog.d/client.conf && systemctl restart rsyslog && { systemctl start iptables 2>/dev/null || true; }" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    if [ -n "${IPTABLES_RULES_FILE}" ] && [ -s "${IPTABLES_RULES_FILE}" ]; then
        iptables-restore <"${IPTABLES_RULES_FILE}" || LOG_WARN "Failed to restore the original iptables rules."
        rm -f "${IPTABLES_RULES_FILE}"
    else
        LOG_WARN "No iptables rules backup found, skip iptables restore."
    fi
    systemctl start iptables 2>/dev/null || LOG_WARN "iptables service is not available, skip it."
    case "${ORIG_SELINUX_MODE:-}" in
    Enforcing) setenforce 1 ;;
    Permissive) setenforce 0 ;;
    *) LOG_WARN "Original selinux mode unknown, skip selinux restore." ;;
    esac
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
    rm -rf /etc/rsyslog.d/server.conf
    systemctl restart rsyslog
    LOG_INFO "End to restore the test environment."
}
main "$@"
