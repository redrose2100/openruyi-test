#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify postgresql rejects duplicate role creation
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    pg_data=/tmp/pgdata_duplicate_role
    role_name=role_duplicate_case
    backup_firewalld_state=$(systemctl is-active firewalld 2>/dev/null)
    backup_selinux_state=$(getenforce 2>/dev/null)
    systemctl stop firewalld >/dev/null 2>&1
    systemctl disable firewalld >/dev/null 2>&1
    command -v setenforce >/dev/null 2>&1 && setenforce 0 >/dev/null 2>&1
    getent group postgres >/dev/null 2>&1 || groupadd postgres
    id postgres >/dev/null 2>&1 || useradd -g postgres postgres
    DNF_INSTALL postgresql-server
    rm -rf "${pg_data}" duplicate_role.log
    mkdir -p "${pg_data}"
    chown -R postgres:postgres "${pg_data}"
    su postgres -c "/usr/bin/initdb -D ${pg_data}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "initdb should initialize the temporary PostgreSQL cluster"
    su postgres -c "/usr/bin/pg_ctl -D ${pg_data} -l ${pg_data}/logfile start" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "pg_ctl should start the temporary PostgreSQL cluster"
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    su postgres -c "psql -d postgres -c \"CREATE ROLE ${role_name} LOGIN;\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "first CREATE ROLE for ${role_name} should succeed"

    su postgres -c "psql -d postgres -c \"CREATE ROLE ${role_name} LOGIN;\"" >duplicate_role.log 2>&1
    CHECK_RESULT $? 0 1 "duplicate CREATE ROLE for ${role_name} should fail"
    grep -i "already exists" duplicate_role.log
    CHECK_RESULT $? 0 0 "duplicate role error should mention that ${role_name} already exists"

    CHECK_RESULT "$(su postgres -c "psql -d postgres -Atqc \"SELECT count(*) FROM pg_roles WHERE rolname='${role_name}';\"")" 1 0 "role ${role_name} should exist exactly once"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    su postgres -c "psql -d postgres -c \"DROP ROLE IF EXISTS ${role_name};\"" >/dev/null 2>&1
    su postgres -c "/usr/bin/pg_ctl -D ${pg_data} -l ${pg_data}/logfile stop" >/dev/null 2>&1
    rm -rf "${pg_data}" duplicate_role.log
    # shellcheck disable=SC2119
    DNF_REMOVE
    if [ "${backup_firewalld_state}" = "active" ]; then
        systemctl enable firewalld >/dev/null 2>&1
        systemctl start firewalld >/dev/null 2>&1
    fi
    if [ "${backup_selinux_state}" = "Enforcing" ]; then
        command -v setenforce >/dev/null 2>&1 && setenforce 1 >/dev/null 2>&1
    fi
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
