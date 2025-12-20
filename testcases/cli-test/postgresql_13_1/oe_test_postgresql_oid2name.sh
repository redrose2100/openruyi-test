#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   oid2name
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "oid2name -d testdb" | grep "testdb"
    CHECK_RESULT $?
    su - postgres -c "oid2name -f 16385" | grep "Filenode"
    CHECK_RESULT $?
    su - postgres -c "oid2name -H 127.0.0.1" | grep "All databases"
    CHECK_RESULT $?
    su - postgres -c "oid2name -i" | grep "All databases"
    CHECK_RESULT $?
    su - postgres -c "oid2name -o 16384" | grep "Filenode"
    CHECK_RESULT $?
    su - postgres -c "oid2name -p 5432" | grep "template0"
    CHECK_RESULT $?
    su - postgres -c "oid2name -q" | grep "template0"
    CHECK_RESULT $?
    su - postgres -c "oid2name -s" | grep "Tablespace Name"
    CHECK_RESULT $?
    su - postgres -c "oid2name -S" | grep "Database Name"
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
