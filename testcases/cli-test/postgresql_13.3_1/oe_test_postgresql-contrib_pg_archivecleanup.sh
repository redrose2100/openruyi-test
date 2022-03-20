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
    #su - postgres -c 'oid2name -t test' | grep "Filenode"
    su - postgres -c 'oid2name -t test' | grep "Filenode"
    CHECK_RESULT $? 0 0 "failed to t oid2name"
    su - postgres -c "oid2name -U postgres" | grep "template0"
    CHECK_RESULT $? 0 0 "failed to connect as specified database user"
    oid2name -V | grep "(PostgreSQL)"
    CHECK_RESULT $? 0 0 "failed to show version"
    su - postgres -c "oid2name -x" | grep "template0"
    CHECK_RESULT $? 0 0 "failed to extended"
    oid2name -? | grep "Usage:"
    CHECK_RESULT $? 0 0 "failed to show help"

    pg_walfile=$(ls /var/lib/pgsql/data/pg_wal | grep "0000")
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile}"
    CHECK_RESULT $? 0 0 "failed to generate debug output"
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile} -n"
    CHECK_RESULT $? 0 0 "failed to generate debug output and dry run"
    pg_archivecleanup -V | grep "(PostgreSQL)"
    CHECK_RESULT $? 0 0 "failed to show output version information"
    su - postgres -c "pg_archivecleanup -d /var/lib/pgsql/data/pg_wal ${pg_walfile} -x .pg"
    CHECK_RESULT $? 0 0 "failed to clean up files"
    pg_archivecleanup -? | grep "Usage:"
    CHECK_RESULT $? 0 0 "failed to show pg_archivecleanup'help"
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
