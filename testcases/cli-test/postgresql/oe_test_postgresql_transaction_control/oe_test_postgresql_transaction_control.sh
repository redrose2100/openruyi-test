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
# @Author    :   liuying
# @Contact   :   liuying03@kylinos.cn
# @Date      :   2026-08-07
# @License   :   Mulan PSL v2
# @Desc      :   Verify postgresql transaction control behavior (COMMIT/ROLLBACK/SAVEPOINT/DDL rollback)
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    pg_data=/tmp/pgdata_tx_isolation
    backup_firewalld_state=$(systemctl is-active firewalld 2>/dev/null)
    backup_selinux_state=$(getenforce 2>/dev/null)
    systemctl stop firewalld >/dev/null 2>&1
    systemctl disable firewalld >/dev/null 2>&1
    command -v setenforce >/dev/null 2>&1 && setenforce 0 >/dev/null 2>&1
    getent group postgres >/dev/null 2>&1 || groupadd postgres
    id postgres >/dev/null 2>&1 || useradd -g postgres postgres
    DNF_INSTALL postgresql-server
    rm -rf "${pg_data}"
    mkdir -p "${pg_data}"
    chown -R postgres:postgres "${pg_data}"
    su postgres -c "/usr/bin/initdb -D ${pg_data}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "initdb should initialize the temporary PostgreSQL cluster"
    su postgres -c "/usr/bin/pg_ctl -D ${pg_data} -l ${pg_data}/logfile start" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "pg_ctl should start the temporary PostgreSQL cluster"
    su postgres -c "psql -d postgres -c \"CREATE TABLE tx_test(id int primary key, val int);\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "tx_test table should be created"
    su postgres -c "psql -d postgres -c \"INSERT INTO tx_test VALUES (1, 100);\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "initial row should be inserted"
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."

    # 1. COMMIT should persist changes
    su postgres -c "psql -d postgres -c \"BEGIN; UPDATE tx_test SET val=200 WHERE id=1; COMMIT;\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "BEGIN/UPDATE/COMMIT should succeed"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT val FROM tx_test WHERE id=1;\"")
    CHECK_RESULT "${actual}" 200 0 "committed update should be visible (expected 200, got ${actual})"

    # 2. ROLLBACK should discard changes
    su postgres -c "psql -d postgres -c \"BEGIN; UPDATE tx_test SET val=999 WHERE id=1; ROLLBACK;\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "BEGIN/UPDATE/ROLLBACK should succeed"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT val FROM tx_test WHERE id=1;\"")
    CHECK_RESULT "${actual}" 200 0 "rolled-back update should not be visible (expected 200, got ${actual})"

    # 3. SAVEPOINT partial rollback (use printf pipe for multi-statement single session)
    printf '%s\n' \
        "BEGIN;" \
        "INSERT INTO tx_test VALUES (2, 10);" \
        "SAVEPOINT sp1;" \
        "INSERT INTO tx_test VALUES (3, 20);" \
        "ROLLBACK TO SAVEPOINT sp1;" \
        "COMMIT;" | su postgres -c "psql -d postgres" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "savepoint partial rollback transaction should succeed"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT count(*) FROM tx_test WHERE id IN (2,3);\"")
    CHECK_RESULT "${actual}" 1 0 "only id=2 should persist after savepoint rollback (expected 1, got ${actual})"

    # 4. DDL inside transaction rollback
    su postgres -c "psql -d postgres -c \"BEGIN; CREATE TABLE tx_temp(a int); ROLLBACK;\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "DDL transaction rollback should succeed"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT count(*) FROM pg_tables WHERE tablename='tx_temp';\"")
    CHECK_RESULT "${actual}" 0 0 "rolled-back table should not exist (expected count 0, got ${actual})"

    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    su postgres -c "/usr/bin/pg_ctl -D ${pg_data} -l ${pg_data}/logfile stop" >/dev/null 2>&1
    rm -rf "${pg_data}"
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
