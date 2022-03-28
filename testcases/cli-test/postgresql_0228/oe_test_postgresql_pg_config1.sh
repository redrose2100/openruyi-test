#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   pg_config
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pg_config --bindir | grep "/usr/bin"
    CHECK_RESULT $?
    pg_config --docdir | grep "/usr/share/doc/pgsql"
    CHECK_RESULT $?
    pg_config --htmldir | grep "/usr/share/doc/pgsql"
    CHECK_RESULT $?
    pg_config --includedir | grep "/usr/include"
    CHECK_RESULT $?
    pg_config --pkgincludedir | grep "/usr/include/pgsql"
    CHECK_RESULT $?
    pg_config --includedir-server | grep "/usr/include/pgsql/server"
    CHECK_RESULT $?
    pg_config --libdir | grep "/usr/lib64"
    CHECK_RESULT $?
    pg_config --pkglibdir | grep "/usr/lib64/pgsql"
    CHECK_RESULT $?
    pg_config --localedir | grep "/usr/share/locale"
    CHECK_RESULT $?
    pg_config --mandir | grep "/usr/share/man"
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
