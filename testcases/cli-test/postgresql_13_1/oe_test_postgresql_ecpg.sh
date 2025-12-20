#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   ecpg
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    su - postgres -c 'echo "EXEC SQL CREATE TABLE testecpg (a int, b varchar(50));" >test.sqc'
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "ecpg -c test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg -C INFORMIX test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg -D test test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg -c test.sqc -h "
    CHECK_RESULT $?
    su - postgres -c "test -f test.h && rm -rf test.h"
    CHECK_RESULT $?
    su - postgres -c "ecpg -i test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg  -I /usr/local/include test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg -c test.sqc -o ecpgfile"
    CHECK_RESULT $?
    su - postgres -c "test -f ecpgfile && rm -rf ecpgfile"
    CHECK_RESULT $?
    su - postgres -c "ecpg -r prepare test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg --regression test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    su - postgres -c "ecpg -t test.sqc"
    CHECK_RESULT $?
    su - postgres -c "test -f test.c && rm -rf test.c"
    CHECK_RESULT $?
    ecpg -V | grep "ecpg"
    CHECK_RESULT $?
    ecpg -? | grep "Usage:"
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
