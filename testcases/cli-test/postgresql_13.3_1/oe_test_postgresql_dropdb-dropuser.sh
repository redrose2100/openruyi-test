#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   dropdb
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    su - postgres -c "createdb tempdb"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "dropdb -e tempdb"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"\l tempdb;\"" | grep tempdb
    CHECK_RESULT $? 1
    su - postgres -c "createdb tempdb"
    expect <<-END
    spawn su - postgres -c "dropdb tempdb -i"
    expect "Are you sure? (y/n) "
    send "y\n"
    expect eof
    exit
END
    su - postgres -c "psql postgres -tAc \"\l tempdb;\"" | grep tempdb
    CHECK_RESULT $? 1
    dropdb -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    su - postgres -c "dropdb tempdb3 --if-exists"
    CHECK_RESULT $?
    dropdb -? | grep "Usage:"
    CHECK_RESULT $?

    su - postgres -c "psql postgres -tAc \"create user testuser with password '123456';\""
    su - postgres -c "dropuser -e testuser"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"create user testuser with password '123456';\""
    expect <<-END
    spawn su - postgres -c "dropuser -i testuser"
    expect "Are you sure? (y/n)"
    send "y\n"
    expect eof
    exit
END
    CHECK_RESULT $?
    dropuser -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"create user testuser with password '123456';\""
    su - postgres -c "dropuser testuser --if-exists"
    CHECK_RESULT $?
    dropuser -? | grep "Usage:"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"create user testuser with password '123456';\""
    su - postgres -c "dropuser testuser -h 127.0.0.1 -U postgres -w -p 5432"
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
