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
    su - postgres -c "postgres -B 150MB &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -c shared_buffers=150MB &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -C shared_buffers"
    CHECK_RESULT $?
    su - postgres -c "postgres -d 3 &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -D /var/lib/pgsql/data/ &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -e &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop -t 5"
    CHECK_RESULT $?
    su - postgres -c "postgres -F &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -h 127.0.0.1 &"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl status" | grep "running (PID"
    CHECK_RESULT $?
    su - postgres -c "pg_ctl stop"
    CHECK_RESULT $?
    su - postgres -c "postgres -i &"
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
