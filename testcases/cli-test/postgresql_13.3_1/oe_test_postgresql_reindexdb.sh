#!/usr/bin/bash


# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2022-02-13
# @License   :   Mulan PSL v2
# @Desc      :   reindexdb
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install
    psql testdb -U postgres -h 127.0.0.1 -c"create index  test1_index  on  test(id,val);"
    psql testdb -U postgres -h 127.0.0.1 -c"create index t_id_1 on test(id);"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    psql testdb -U postgres -h 127.0.0.1 -c"insert into test select generate_series(1,10000),random();"
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t)
    su - postgres -c "reindexdb -a"
    CHECK_RESULT $? 
    temp2=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t)
    [ $temp1 -gt $temp2 ]
    CHECK_RESULT $?
    psql testdb -U postgres -h 127.0.0.1 -c "insert into test select generate_series(1,10000),random();"
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t | tr -cd "[0-9]")
    su - postgres -c "reindexdb -d testdb"
    CHECK_RESULT $? 
    temp2=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t | tr -cd "[0-9]")
    [ $temp1 -gt $temp2 ]
    CHECK_RESULT $? 
    su - postgres -c "reindexdb -e"
    CHECK_RESULT $?
    psql testdb -U postgres -h 127.0.0.1 -c"insert into test select generate_series(1,10000),random();"
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_size_pretty(pg_relation_size('t_id_1'));" -A -0 -t | tr -cd "[0-9]")
    echo "$temp1"
    su - postgres -c "reindexdb -i t_id_1 -d testdb"
    CHECK_RESULT $? 
    temp2=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_size_pretty(pg_relation_size('t_id_1'));" -A -0 -t | tr -cd "[0-9]")
    echo "$temp2"
    [ $temp1 -ge $temp2 ]
    CHECK_RESULT $?
    su - postgres -c "reindexdb -q"
    CHECK_RESULT $? 
    reindexdb -? | grep "Usage:"
    CHECK_RESULT $?
    psql testdb -U postgres -h 127.0.0.1 -c "insert into myschema.test select generate_series(1,100000),random();"
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_size_pretty(pg_relation_size('test1_index'));" -A -0 -t | tr -cd "[0-9]")
    su - postgres -c "reindexdb -S myschema -d testdb"
    CHECK_RESULT $? 
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_size_pretty(pg_relation_size('test1_index'));" -A -0 -t | tr -cd "[0-9]")
    [ $temp1 -gt $temp2 ]
    CHECK_RESULT $? 
    psql testdb -U postgres -h 127.0.0.1 -c "insert into test select generate_series(1,10000),random();"
    temp1=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t)
    su - postgres -c "reindexdb -t test -d testdb"
    CHECK_RESULT $? 
    temp2=$(psql testdb -U postgres -h 127.0.0.1 -c "select pg_indexes_size('test');" -A -0 -t)
    [ $temp1 -gt $temp2 ]
    CHECK_RESULT $? 
    su - postgres -c "reindexdb -v" 2>&1 | grep "DETAIL"
    CHECK_RESULT $? 
    reindexdb -V | grep "PostgreSQL"
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
