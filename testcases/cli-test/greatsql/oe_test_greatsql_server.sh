#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Test greatsql-server
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "greatsql-client greatsql-server greatsql-test"
    # rm -rf /var/lib/mysql/*
    systemctl start mysqld.service
    temporary_password=$(grep 'temporary password' /var/log/mysqld.log | tail -1 | awk '{print $NF}')
    default_password="openEuler12#$"
    mysql --connect-expired-password -uroot -p"${temporary_password}" -e "ALTER USER USER() IDENTIFIED BY '${default_password}';"
    LOG_INFO "End to prepare the stest environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    mysqlslap -uroot -p"$default_password" --concurrency=50 --iterations=10 --auto-generate-sql --auto-generate-sql-load-type=mixed --auto-generate-sql-add-autoincrement
    CHECK_RESULT $?

    mysql -uroot -p"${default_password}" -e "DROP DATABASE test;" 

    cat > mysql_client_test.sql <<EOF
CREATE DATABASE test;

USE test;

-- 创建一个简单的表
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

-- 插入一些初始数据
INSERT INTO test_table (name, age) VALUES ('Alice', 25), ('Bob', 30);

-- 创建一个包含多种数据类型的表
CREATE TABLE test_data_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tinyint_field TINYINT,
    smallint_field SMALLINT,
    int_field INT,
    bigint_field BIGINT,
    float_field FLOAT,
    double_field DOUBLE,
    char_field CHAR(10),
    varchar_field VARCHAR(50),
    date_field DATE,
    datetime_field DATETIME,
    time_field TIME
);

-- 插入一些初始数据
INSERT INTO test_data_types (
    tinyint_field, smallint_field, int_field, bigint_field,
    float_field, double_field, char_field, varchar_field,
    date_field, datetime_field, time_field
) VALUES (
    1, 100, 1000, 1000000, 3.14, 2.71828, 'char', 'varchar', '2025-06-15', '2025-06-15 12:00:00', '12:00:00'
);
EOF

    mysql -uroot -p"${default_password}" < ./mysql_client_test.sql
    CHECK_RESULT $?
    mysql -uroot -p"${default_password}" -e "SHOW DATABASES;" | grep "test"
    CHECK_RESULT $?

    mysql_client_test -p"$default_password" client_query
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_insert
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_update
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_simple_delete
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_select
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_create_drop
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_rename
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_long
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_short
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_tiny
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_bigint
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_float
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_double
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_str
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_fetch_date
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_temporal_param
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_decimal_bug
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_tran_innodb
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_simple_update
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_simple_delete
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_prepare
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_prepare_simple
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_prepare_noparam
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_ps_null_param
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_bind_result
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_bind_result_ext
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_prepare_multi_statements
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_view
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_view_where
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_view_star
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_subselect
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_union
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_join
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_left_join_view
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_warnings
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_parse_error_and_bad_length
    CHECK_RESULT $?
    mysql_client_test -p"$default_password" test_time_zone
    CHECK_RESULT $?

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop mysqld.service
    DNF_REMOVE "$@"
    sudo rm -rf /var/lib/mysql/* ./query.sql

    LOG_INFO "End to restore the test environment."
}

main "$@"
