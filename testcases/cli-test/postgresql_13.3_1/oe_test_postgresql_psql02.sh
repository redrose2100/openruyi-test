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
    su - postgres -c "psql -L psqlfile2 -c \"select * from pg_roles;\""
    CHECK_RESULT $?
    test -f /var/lib/pgsql/psqlfile2
    CHECK_RESULT $?
    su - postgres -c "psql -o psqlfile3 -c \"select * from pg_roles;\""
    CHECK_RESULT $?
    test -f /var/lib/pgsql/psqlfile3
    CHECK_RESULT $?
    su - postgres -c "psql -q -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    su - postgres -c "psql -s -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    expect <<-END
    spawn su - postgres -c "psql -s -c \"select * from pg_roles;\"" | grep "rolname"
    expect "*Single*"
    send "\n"
    expect eof
END
    CHECK_RESULT $?
    su - postgres -c "psql -b -c \"select * from pg_roles;\"" | grep "rolname"
    CHECK_RESULT $?
    echo "select * from pg_roles;" >/var/lib/pgsql/psqlfile1
    su - postgres -c "psql -a -f psqlfile1"
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
