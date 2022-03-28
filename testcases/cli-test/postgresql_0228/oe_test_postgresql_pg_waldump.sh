#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   pg_waldump
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    checkpoint=$(su - postgres -c "pg_controldata" | grep "Prior checkpoint location:" | awk '{printf $4}')
    WALfile=$(su - postgres -c "pg_controldata" | grep "Latest checkpoint's REDO WAL file:" | awk '{printf $6}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "pg_waldump ${WALfile} -n 3 -b" | grep "rmgr"
    CHECK_RESULT $?
    su - postgres -c "pg_waldump ${WALfile} -s ${checkpoint} -n 3" | grep "rmgr"
    CHECK_RESULT $?
    su - postgres -c "pg_waldump ${WALfile} -f -s ${checkpoint} -n 3" | grep "rmgr"
    CHECK_RESULT $?
    su - postgres -c "pg_waldump ${WALfile} -n 3" | grep "rmgr"
    CHECK_RESULT $?
    su - postgres -c "pg_waldump -p /var/lib/pgsql/data/pg_wal ${WALfile} -n 1" | grep "rmgr"
    CHECK_RESULT $?
    su - postgres -c "pg_waldump ${WALfile} -r Heap -n 3" | grep "rmgr"
    CHECK_RESULT $?
    pg_waldump -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    pg_waldump -? | grep "Usage:"
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
