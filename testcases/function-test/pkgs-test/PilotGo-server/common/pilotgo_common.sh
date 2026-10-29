#!/usr/bin/bash
# Copyright (c) 2026. OpenAtom Foundation.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2026/09/08
# @License   :   Mulan PSL v2
# @Desc      :   pilotgo systemd service test common functions
# ############################################
# shellcheck disable=SC1091
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pilotgo_prepare_base_server() {
    LOG_INFO "Prepare pilotgo base services."

    DNF_INSTALL "mysql-server redis6 PilotGo-server firewalld"
    # firewalld/selinux are only changed for the duration of this run;
    # post_test restores the state recorded here.
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    ORIG_SELINUX_MODE=$(getenforce 2>/dev/null)
    systemctl stop firewalld

    systemctl restart mysqld
    CHECK_RESULT $?
    systemctl is-active mysqld | grep -w active
    CHECK_RESULT $?
    systemctl restart redis
    CHECK_RESULT $?
    systemctl is-active redis | grep -w active
    CHECK_RESULT $?

    cp /opt/PilotGo/server/config_server.yaml /opt/PilotGo/server/config_server.yaml.bak
    sed -i 's#path:.*#path: "/tmp/pilotgo-data"#' /opt/PilotGo/server/config_server.yaml

    mkdir -p /tmp/pilotgo-data
    systemctl restart PilotGo-server
    CHECK_RESULT $?
    SLEEP_WAIT 5
    systemctl is-active PilotGo-server | grep -w active
    CHECK_RESULT $?
}

function pilotgo_cleanup_base_server() {
    systemctl stop PilotGo-server
    systemctl stop redis
    systemctl stop mysqld
    cp /opt/PilotGo/server/config_server.yaml.bak /opt/PilotGo/server/config_server.yaml
    rm -rf /tmp/pilotgo-data
    rm -f /opt/PilotGo/server/config_server.yaml.bak
    case "${ORIG_SELINUX_MODE:-}" in
    Enforcing) setenforce 1 ;;
    Permissive) setenforce 0 ;;
    *) LOG_WARN "Original selinux mode unknown, skip selinux restore." ;;
    esac
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
}
