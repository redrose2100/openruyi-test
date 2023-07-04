#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   pgsql_backup
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "pg_ctl -D data start"
    rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
    su - postgres -c "pg_basebackup -D /tmp/pgsql_backup/ -Ft -R -z -v -c fast" 2>&1 | grep "base backup completed"
    CHECK_RESULT $?
    rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
    su - postgres -c "pg_basebackup -D /tmp/pgsql_backup/ -P" 2>&1 | grep "100%"
    CHECK_RESULT $?
    rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
    su - postgres -c "pg_basebackup -D /tmp/pgsql_backup/ -l sss"
    CHECK_RESULT $?
    test -d /tmp/pgsql_backup/ && rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
    CHECK_RESULT $?
    su - postgres -c "pg_basebackup -D /tmp/pgsql_backup/ -Z 1 -Ft"
    CHECK_RESULT $?
    test -d /tmp/pgsql_backup/ && rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
    CHECK_RESULT $?
    pg_basebackup -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    pg_basebackup -? | grep "Usage:"
    CHECK_RESULT $?
    su - postgres -c "pg_basebackup -D /tmp/pgsql_backup/ -s 10  -h 127.0.0.1 -U postgres -w -p 5432"
    CHECK_RESULT $?
    test -d /tmp/pgsql_backup/ && rm -rf /tmp/pgsql_backup/ /var/lib/pgsql/dbdir
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
