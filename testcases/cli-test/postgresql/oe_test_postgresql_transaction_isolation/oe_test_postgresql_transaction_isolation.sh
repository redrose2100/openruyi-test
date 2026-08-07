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
# @Author    :   mugen
# @Contact   :   mugen@openeuler.org
# @Date      :   2026-08-07
# @License   :   Mulan PSL v2
# @Desc      :   Verify postgresql transaction control and isolation level behavior
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
    rm -rf "${pg_data}" tx_isolation.log tx_rc_out.txt tx_rr_out.txt
    mkdir -p "${pg_data}"
    chown -R postgres:postgres "${pg_data}"
    su postgres -c "/usr/bin/initdb -D ${pg_data}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "initdb should initialize the temporary PostgreSQL cluster"
    # Enable prepared transactions for two-phase commit test
    echo "max_prepared_transactions = 10" >>"${pg_data}/postgresql.conf"
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

    # 5. READ COMMITTED isolation: within a single transaction, a concurrent
    #    committed update from another session IS visible to the next statement.
    #    Background an expect-driven psql session, run a concurrent UPDATE during
    #    the in-expect sleep, then wait for the session to finish.
    rm -f tx_rc_out.txt
    expect <<-'EOF' >tx_rc_out.txt 2>&1 &
        set timeout 15
        spawn su postgres -c "psql -d postgres -t -A"
        expect "postgres="
        send "BEGIN ISOLATION LEVEL READ COMMITTED;\r"
        expect "postgres="
        send "SELECT val FROM tx_test WHERE id=1;\r"
        expect "postgres="
        sleep 3
        send "SELECT val FROM tx_test WHERE id=1;\r"
        expect "postgres="
        send "COMMIT;\r"
        expect "postgres="
        send "\\q\r"
        expect eof
EOF
    sleep 1
    su postgres -c "psql -d postgres -c \"UPDATE tx_test SET val=300 WHERE id=1;\"" >/dev/null 2>&1
    wait
    rc_read1=$(sed -n '1p' tx_rc_out.txt | tr -d '[:space:]')
    rc_read2=$(sed -n '2p' tx_rc_out.txt | tr -d '[:space:]')
    CHECK_RESULT "${rc_read1}" 200 0 "READ COMMITTED: first read should see pre-update value 200 (got ${rc_read1})"
    CHECK_RESULT "${rc_read2}" 300 0 "READ COMMITTED: second read should see concurrent committed value 300 (got ${rc_read2})"

    # 6. REPEATABLE READ isolation: within a single transaction, a concurrent
    #    committed update from another session is NOT visible — snapshot is stable.
    rm -f tx_rr_out.txt
    expect <<-'EOF' >tx_rr_out.txt 2>&1 &
        set timeout 15
        spawn su postgres -c "psql -d postgres -t -A"
        expect "postgres="
        send "BEGIN ISOLATION LEVEL REPEATABLE READ;\r"
        expect "postgres="
        send "SELECT val FROM tx_test WHERE id=1;\r"
        expect "postgres="
        sleep 3
        send "SELECT val FROM tx_test WHERE id=1;\r"
        expect "postgres="
        send "COMMIT;\r"
        expect "postgres="
        send "\\q\r"
        expect eof
EOF
    sleep 1
    su postgres -c "psql -d postgres -c \"UPDATE tx_test SET val=400 WHERE id=1;\"" >/dev/null 2>&1
    wait
    rr_read1=$(sed -n '1p' tx_rr_out.txt | tr -d '[:space:]')
    rr_read2=$(sed -n '2p' tx_rr_out.txt | tr -d '[:space:]')
    CHECK_RESULT "${rr_read1}" 300 0 "REPEATABLE READ: first read should see pre-update value 300 (got ${rr_read1})"
    CHECK_RESULT "${rr_read2}" 300 0 "REPEATABLE READ: second read should still see 300 (snapshot stable, got ${rr_read2})"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT val FROM tx_test WHERE id=1;\"")
    CHECK_RESULT "${actual}" 400 0 "after REPEATABLE READ session ends, latest committed value 400 should be visible (got ${actual})"

    # 7. SERIALIZABLE isolation level should be accepted
    su postgres -c "psql -d postgres -c \"BEGIN ISOLATION LEVEL SERIALIZABLE; SELECT count(*) FROM tx_test; COMMIT;\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "SERIALIZABLE isolation level transaction should succeed"

    # 8. Error inside transaction: duplicate primary key should fail
    su postgres -c "psql -d postgres -c \"BEGIN; INSERT INTO tx_test VALUES (1, 1); COMMIT;\"" >tx_isolation.log 2>&1
    actual=$?
    CHECK_RESULT ${actual} 0 1 "duplicate primary key insert should fail (expected non-zero exit)"
    grep -i "duplicate key" tx_isolation.log >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "error log should mention duplicate key violation"

    # 9. Two-phase commit (PREPARE TRANSACTION / COMMIT PREPARED)
    su postgres -c "psql -d postgres -c \"BEGIN; UPDATE tx_test SET val=500 WHERE id=1; PREPARE TRANSACTION 'tx_gid';\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "PREPARE TRANSACTION should succeed"
    su postgres -c "psql -d postgres -c \"COMMIT PREPARED 'tx_gid';\"" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "COMMIT PREPARED should succeed"
    actual=$(su postgres -c "psql -d postgres -Atqc \"SELECT val FROM tx_test WHERE id=1;\"")
    CHECK_RESULT "${actual}" 500 0 "two-phase commit should persist update (expected 500, got ${actual})"

    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    su postgres -c "/usr/bin/pg_ctl -D ${pg_data} -l ${pg_data}/logfile stop" >/dev/null 2>&1
    rm -rf "${pg_data}" tx_isolation.log tx_rc_out.txt tx_rr_out.txt
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
