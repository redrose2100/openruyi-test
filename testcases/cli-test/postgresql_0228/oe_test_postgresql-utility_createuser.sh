#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   createuser
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "createuser testuser1"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep testuser1"
    CHECK_RESULT $?
    su - postgres -c "createuser testuser2 -c 222"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep testuser2 | grep 222"
    CHECK_RESULT $?
    su - postgres -c "createuser  testuser3 -d"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"select * from pg_roles;\" | grep \"testuser3|f|t|f|t\""
    CHECK_RESULT $?
    su - postgres -c "createuser  testuser4 -D"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"select * from pg_roles;\" | grep \"testuser4|f|t|f|f\""
    CHECK_RESULT $?
    su - postgres -c "createuser -e testuser5"
    CHECK_RESULT $?
    su - postgres -c "createuser testuser6 -g postgres"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc \"\du;\"" | grep -E "testuser6|postgres"
    CHECK_RESULT $?
    su - postgres -c "createuser testuser7 -i"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep \"testuser7|f|t\""
    CHECK_RESULT $?
    su - postgres -c "createuser testuser8 -I"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep \"testuser8|f|f\""
    CHECK_RESULT $?
    su - postgres -c "createuser testuser9 -l"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep \"testuser9|f|t|f|f|t\""
    CHECK_RESULT $?
    su - postgres -c "createuser testuser10 -L"
    CHECK_RESULT $?
    su - postgres -c "psql postgres -tAc  \"select * from pg_roles;\" | grep \"testuser10|f|t|f|f|f\""
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
