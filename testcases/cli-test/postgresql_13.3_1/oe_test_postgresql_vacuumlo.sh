#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   vacuumlo
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "vacuumlo -l 1000 testdb"
    CHECK_RESULT $?
    su - postgres -c "vacuumlo -n testdb" | grep "Connected to database"
    CHECK_RESULT $?
    su - postgres -c "vacuumlo -l 1000 testdb -v" 2>&1 | grep "Connected to database"
    CHECK_RESULT $?
    vacuumlo -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    vacuumlo -? | grep "Usage:"
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
