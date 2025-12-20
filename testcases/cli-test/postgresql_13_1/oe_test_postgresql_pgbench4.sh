#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   clusterdb
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "pgbench -i"
    su - postgres -c "pgbench -b tpcb-like" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c 'echo "SELECT abalance FROM pgbench_accounts WHERE aid = \:aid;" >test.c'
    su - postgres -c "pgbench -f test.c" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -N" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -h 127.0.0.1 -U postgres -p 5432 -d postgres" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    pgbench -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    pgbench -? | grep "Usage:"
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
