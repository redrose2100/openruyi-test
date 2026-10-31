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
# @Desc      :   Forward HTTPD logs to other virtual machines
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "httpd"
    # firewalld/iptables/selinux are only changed for the duration of this run;
    # post_test restores the state recorded here.
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    ORIG_SELINUX_MODE=$(getenforce 2>/dev/null)
    IPTABLES_RULES_FILE=$(mktemp /tmp/iptables_rules.XXXXXX)
    iptables-save >"${IPTABLES_RULES_FILE}" 2>/dev/null
    setenforce 0
    iptables -F
    systemctl stop firewalld
    systemctl restart httpd
    SSH_CMD "
    iptables-save > /tmp/iptables_rules.node2.bak 2>/dev/null
    setenforce 0
    iptables -F
    systemctl stop firewalld
    sed -i '/apache-error/d' /var/log/messages
    sed -i '/apache-access/d' /var/log/messages
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat >/etc/rsyslog.d/client.conf <<EOF
    \$ModLoad imfile
    \$InputFilePollInterval 10
    \$InputFileName /var/log/httpd/access_log
    \$InputFileTag apache-access
    \$InputFileStateFile stat-apache-access
    \$InputFileSeverity info
    \$InputFilePersistStateInterval 25000
    \$InputRunFileMonitor
    \$InputFileName /var/log/httpd/error_log
    \$InputFileTag apache-error
    \$InputFileStateFile stat-apache-error
    \$InputFileSeverity error
    \$InputFilePersistStateInterval 25000
    \$InputRunFileMonitor
    if \$programname == 'apache-access' then @@${NODE2_IPV4}
    if \$programname == 'apache-access' then ~
    if \$programname == 'apache-error' then @@${NODE2_IPV4}
    if \$programname == 'apache-error' then ~
EOF
    systemctl restart rsyslog
    CHECK_RESULT $?
    SSH_CMD "
    echo  '\$ModLoad imtcp\n\$InputTCPServerRun 514\n*.* /var/log/test' > /etc/rsyslog.d/server.conf
    systemctl restart rsyslog
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    SLEEP_WAIT 20
    echo "hello world" >>/var/log/httpd/access_log
    systemctl restart httpd
    SLEEP_WAIT 20
    SSH_CMD "grep 'apache-access' /var/log/test" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    SSH_CMD "grep 'apache-error' /var/log/test" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    SSH_CMD "iptables-restore < /tmp/iptables_rules.node2.bak 2>/dev/null && rm -f /tmp/iptables_rules.node2.bak; rm -rf /etc/rsyslog.d/server.conf && systemctl restart rsyslog" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    if [ -n "${IPTABLES_RULES_FILE}" ] && [ -s "${IPTABLES_RULES_FILE}" ]; then
        iptables-restore <"${IPTABLES_RULES_FILE}" || LOG_WARN "Failed to restore the original iptables rules."
        rm -f "${IPTABLES_RULES_FILE}"
    else
        LOG_WARN "No iptables rules backup found, skip iptables restore."
    fi
    case "${ORIG_SELINUX_MODE:-}" in
    Enforcing) setenforce 1 ;;
    Permissive) setenforce 0 ;;
    *) LOG_WARN "Original selinux mode unknown, skip selinux restore." ;;
    esac
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
    rm -rf /etc/rsyslog.d/client.conf
    systemctl restart rsyslog
    LOG_INFO "End to restore the test environment."
}

main "$@"
