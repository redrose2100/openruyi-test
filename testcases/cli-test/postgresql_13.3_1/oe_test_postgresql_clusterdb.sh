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
    su - postgres -c "clusterdb -a" | grep "clustering database"
    CHECK_RESULT $?
    su - postgres -c "clusterdb -d testdb"
    CHECK_RESULT $?
    su - postgres -c "clusterdb -e" | grep "CLUSTER"
    CHECK_RESULT $?
    su - postgres -c "clusterdb -a -q"
    CHECK_RESULT $?
    su - postgres -c "clusterdb -a -v" | grep "clustering database"
    CHECK_RESULT $?
    clusterdb -V | grep "(PostgreSQL)"
    CHECK_RESULT $?
    clusterdb -? | grep "Usage:"
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
