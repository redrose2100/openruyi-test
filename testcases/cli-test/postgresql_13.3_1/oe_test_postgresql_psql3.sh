#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   psql
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "psql -A -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -F \"\|\" -A -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -H -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -P format=latex -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -R / -A -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -t -c \"select * from pg_roles;\"" | grep "postgres"
    CHECK_RESULT $?
    su - postgres -c "psql -T “ss” -H -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -x -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -z -A -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -0 -A -c \"select * from pg_roles;\"" | grep "rolname"
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
