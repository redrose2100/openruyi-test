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
    su - postgres -c "pgbench -S" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    rm -rf test.c
    su - postgres -c "pgbench -c 2" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -C" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -D sleep=3" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -j 2" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    rm -rf test.*
    su - postgres -c "pgbench --log-prefix=test -l" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -L 1" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -M simple" 2>&1 | grep "starting vacuum...end"
    CHECK_RESULT $?
    su - postgres -c "pgbench -n" 2>&1 | grep "scaling"
    CHECK_RESULT $?
    su - postgres -c "pgbench -P 1 --progress-timestamp" 2>&1 | grep "starting vacuum...end"
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
