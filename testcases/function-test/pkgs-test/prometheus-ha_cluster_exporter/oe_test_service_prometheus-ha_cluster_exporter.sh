#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/6/4
# @License   :   Mulan PSL v2
# @Desc      :   Test prometheus-ha_cluster_exporter.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/ha.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "pcs pacemaker fence-virt fence-agents corosync corosync-qdevice prometheus-ha_cluster_exporter"
    service=prometheus-ha_cluster_exporter.service
    echo 'web:
    listen-address: "0.0.0.0:9664"
    telemetry-path: "/metrics"
    config:
        file: "/etc/ha_cluster_exporter.web.yaml"
log:
    level: "info"
    format: "logfmt"
crm-mon-path: "/usr/sbin/crm_mon"
cibadmin-path: "/usr/sbin/cibadmin"
corosync-cfgtoolpath-path: "/usr/sbin/corosync-cfgtool"
corosync-quorumtool-path: "/usr/sbin/corosync-quorumtool"
sbd-path: "/usr/sbin/sbd"
sbd-config-path: "/etc/sysconfig/sbd"
drbdsetup-path: "/sbin/drbdsetup"' >/etc/ha_cluster_exporter.yaml
    echo "tls_server_config:
    cert_file: server.crt
    key_file: server.key
basic_auth_users:
    alice: \$2y\$10\$mDwo.lAisC94iLAyP81MCesa29IzH37oigHC/42V2pdJlUprsJPze
    bob: \$2y\$10\$hLqFl9jSjoAAy95Z/zw8Ye8wkdMBM8c5Bn1ptYqP/AXyV0.oy0S8m" >/etc/ha_cluster_exporter.web.yaml
    openssl genrsa -out server.key 2048
    openssl req -nodes -new -key server.key -subj "/CN=localhost" -out server.csr
    openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
    cp -f server.key server.crt /etc
    log_time="$(date '+%Y-%m-%d %T')"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_restart "${service}"
    test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -vi "DEBUG\|INFO\|WARNING\|'/sbin/drbdsetup' does not exist"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    test_reload "${service}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf /etc/ha_cluster_exporter.yaml /etc/ha_cluster_exporter.web.yaml /etc/server.key /etc/server.crt ./server.*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
