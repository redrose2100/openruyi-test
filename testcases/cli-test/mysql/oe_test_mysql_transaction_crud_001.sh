#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuying
# @Contact   :   liuying03@kylinos.cn
# @Date      :   2026-08-07
# @License   :   Mulan PSL v2
# @Desc      :   verify MySQL transaction control and CRUD operations
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    version_id=$(grep "VERSION_ID" /etc/os-release | awk -F "=" '{print $NF}' | awk -F "\"" '{print $2}')
    if [ "${version_id}" = "20.03" ]; then
        exit 0
    fi
    rm -rf /var/lib/mysql/*
    DNF_INSTALL mysql-server
    systemctl start mysqld
    mysql -e "CREATE DATABASE test_crud;"
    mysql -e "use test_crud; CREATE TABLE t_crud (id INT, name VARCHAR(50), value INT) ENGINE=InnoDB;"
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    # Test 1: COMMIT persistence
    mysql -e "use test_crud; BEGIN; INSERT INTO t_crud VALUES(1,'test1',100); UPDATE t_crud SET value=200 WHERE id=1; COMMIT;"
    CHECK_RESULT $? 0 0 "COMMIT: transaction should execute successfully"
    mysql -e "use test_crud; SELECT value FROM t_crud WHERE id=1;" | grep "200"
    CHECK_RESULT $? 0 0 "COMMIT: value should be 200 after commit"
    mysql -e "use test_crud; SELECT name FROM t_crud WHERE id=1;" | grep "test1"
    CHECK_RESULT $? 0 0 "COMMIT: name should be test1 after commit"

    # Test 2: ROLLBACK discard
    mysql -e "use test_crud; BEGIN; UPDATE t_crud SET value=999 WHERE id=1; INSERT INTO t_crud VALUES(2,'test2',300); ROLLBACK;"
    CHECK_RESULT $? 0 0 "ROLLBACK: transaction should execute successfully"
    mysql -e "use test_crud; SELECT value FROM t_crud WHERE id=1;" | grep "200"
    CHECK_RESULT $? 0 0 "ROLLBACK: value should remain 200"
    mysql -e "use test_crud; SELECT COUNT(*) FROM t_crud WHERE id=2;" | grep "0"
    CHECK_RESULT $? 0 0 "ROLLBACK: id=2 should not exist"

    # Test 3: SAVEPOINT partial rollback
    mysql -e "use test_crud; BEGIN; INSERT INTO t_crud VALUES(10,'sp1',1000); SAVEPOINT sp_test; INSERT INTO t_crud VALUES(11,'sp2',2000); ROLLBACK TO SAVEPOINT sp_test; COMMIT;"
    CHECK_RESULT $? 0 0 "SAVEPOINT: transaction should execute successfully"
    mysql -e "use test_crud; SELECT COUNT(*) FROM t_crud WHERE id=10;" | grep "1"
    CHECK_RESULT $? 0 0 "SAVEPOINT: id=10 should exist"
    mysql -e "use test_crud; SELECT COUNT(*) FROM t_crud WHERE id=11;" | grep "0"
    CHECK_RESULT $? 0 0 "SAVEPOINT: id=11 should not exist"

    # Test 4: DDL implicit commit
    mysql -e "use test_crud; BEGIN; INSERT INTO t_crud VALUES(20,'ddl1',500); CREATE TABLE t_ddl_test (id INT) ENGINE=InnoDB; ROLLBACK;"
    CHECK_RESULT $? 0 0 "DDL implicit commit: transaction should execute successfully"
    mysql -e "use test_crud; SELECT COUNT(*) FROM t_crud WHERE id=20;" | grep "1"
    CHECK_RESULT $? 0 0 "DDL implicit commit: id=20 should exist"
    mysql -e "use test_crud; SHOW TABLES LIKE 't_ddl_test';" | grep "t_ddl_test"
    CHECK_RESULT $? 0 0 "DDL implicit commit: t_ddl_test table should exist"

    # Test 5: CRUD lifecycle
    mysql -e "use test_crud; INSERT INTO t_crud VALUES(30,'crud1',1000);"
    CHECK_RESULT $? 0 0 "CRUD INSERT: should execute successfully"
    mysql -e "use test_crud; SELECT name FROM t_crud WHERE id=30;" | grep "crud1"
    CHECK_RESULT $? 0 0 "CRUD INSERT: should find id=30 with name crud1"
    mysql -e "use test_crud; UPDATE t_crud SET name='crud1_updated' WHERE id=30;"
    CHECK_RESULT $? 0 0 "CRUD UPDATE: should execute successfully"
    mysql -e "use test_crud; SELECT name FROM t_crud WHERE id=30;" | grep "crud1_updated"
    CHECK_RESULT $? 0 0 "CRUD UPDATE: name should be crud1_updated"
    mysql -e "use test_crud; BEGIN; DELETE FROM t_crud WHERE id=30; ROLLBACK;"
    CHECK_RESULT $? 0 0 "CRUD DELETE ROLLBACK: transaction should execute successfully"
    mysql -e "use test_crud; SELECT COUNT(*) FROM t_crud WHERE id=30;" | grep "1"
    CHECK_RESULT $? 0 0 "CRUD DELETE ROLLBACK: id=30 should be restored"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    mysql -e "DROP DATABASE IF EXISTS test_crud;"
    systemctl stop mysqld
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
