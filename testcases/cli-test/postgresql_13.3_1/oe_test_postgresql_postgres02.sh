#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   postgres
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c 'postgres  -o "-p 5222" &'
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres  -N 33 &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres  -p 5434 & "
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres  -s &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres  -S 1234 &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    postgres -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    postgres -? | grep "Usage:"
    CHECK_RESULT $?
    su - postgres -c "postgres -k /tmp &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
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
