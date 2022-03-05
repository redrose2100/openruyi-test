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
    su - postgres -c "psql -c \"select * from pg_roles;\""
    CHECK_RESULT $?
    expect <<-END
    spawn su - postgres -c "psql -d template1"
    expect "template1=#"
    send "\\q\n"
    expect eof
    exit
END
    CHECK_RESULT $?
    echo "select * from pg_roles;" >/var/lib/pgsql/psqlfile1
    su - postgres -c "psql -f psqlfile1" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -l" | grep "List of databases"
    CHECK_RESULT $?
    echo "select * from pg_roles where rolname=:'1';" >/var/lib/pgsql/psqlfile1
    su - postgres -c "psql -v 1='postgres' -f psqlfile1"
    CHECK_RESULT $?
    psql -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    echo "\set rolname postgres" >~/.psqlrc
    expect <<-END
    spawn su - postgres -c "psql -X"
    expect "postgres=#"
    send "select * from pg_roles;\n"
    expect "template1=#"
    send "\\q\n"
    expect eof
    exit
END
    CHECK_RESULT $?
    psql -? | grep "Usage:"
    CHECK_RESULT $?
    su - postgres -c "psql -e -c \"select * from pg_roles;\"" | grep "rolname"
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
