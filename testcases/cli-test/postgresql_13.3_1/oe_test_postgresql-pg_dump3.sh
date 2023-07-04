#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   pg_dump
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "pg_dump -Z 1 -Ft -Fd testdb -f tmpdir >testfile"
    CHECK_RESULT $?
    grep "grant" /var/lib/pgsql/testfile
    CHECK_RESULT $? 1
    su - postgres -c "pg_dump testdb -Z 0" | grep "database dump complete"
    CHECK_RESULT $?
    pg_dump -? | grep "Usage:"
    CHECK_RESULT $?
    su - postgres -c "pg_dump testdb --column-inserts >testfile"
    CHECK_RESULT $?
    grep "INSERT INTO public.test (id, val) VALUES (10000" /var/lib/pgsql/testfile
    CHECK_RESULT $?
    su - postgres -c "pg_dump testdb --enable-row-security >testfile"
    CHECK_RESULT $?
    grep "SET row_security = on" /var/lib/pgsql/testfile
    CHECK_RESULT $?
    su - postgres -c "pg_dump testdb --exclude-table-data=tab_big >testfile"
    CHECK_RESULT $?
    grep "Data for Name: test; Type: TABLE DATA; Schema: " /var/lib/pgsql/testfile
    CHECK_RESULT $?
    su - postgres -c "pg_dump testdb --inserts >testfile"
    CHECK_RESULT $?
    grep "INSERT INTO public.test VALUES (1000" /var/lib/pgsql/testfile
    CHECK_RESULT $?
    su - postgres -c "pg_dump testdb -h 127.0.0.1 -U postgres -w -p 5432"
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
