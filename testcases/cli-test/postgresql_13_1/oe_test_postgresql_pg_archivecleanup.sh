#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   pg_archivecleanup oid2name
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c 'oid2name -t test "oid2name"' | grep "Filenode"
    CHECK_RESULT $?
    su - postgres -c "oid2name -U postgres" | grep "template0"
    CHECK_RESULT $?
    oid2name -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    su - postgres -c "oid2name -x" | grep "template0"
    CHECK_RESULT $?
    oid2name -? | grep "Usage:"
    CHECK_RESULT $?

    pg_walfile=$(ls /var/lib/pgsql/data/pg_wal | grep "0000")
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile}"
    CHECK_RESULT $?
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile} -n"
    CHECK_RESULT $?
    pg_archivecleanup -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile} -x .pg"
    CHECK_RESULT $?
    pg_archivecleanup -? | grep "Usage:"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop postgresql
    DNF_REMOVE
    rm -rf /var/lib/pgsql/*
    LOG_INFO "End to restore the test environment."
}
main "$@"
