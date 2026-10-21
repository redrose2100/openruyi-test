#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/09/04
# @License   :   Mulan PSL v2
# @Desc      :   Test opengauss gsql backup and restore
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL opengauss
    systemctl start opengauss.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    su - opengauss -c "gsql --version"| grep -E 'openGauss.*build'
    CHECK_RESULT $?

    su - opengauss -c "gsql -d postgres -c '\echo :VERSION'" | grep -E 'openGauss.*build'
    CHECK_RESULT $?

    su - opengauss -c "gsql -d postgres -c \"ALTER ROLE opengauss PASSWORD 'openEuler12';\"" | grep "ALTER ROLE"
    CHECK_RESULT $?

    su - opengauss -c "gsql -d postgres -c 'SELECT datname FROM pg_database;'" | grep datname
    CHECK_RESULT $?

    su - opengauss -c "gsql -d postgres -c 'CREATE DATABASE dumptest;'" | grep "CREATE DATABASE"
    CHECK_RESULT $?

    su - opengauss -c "gsql -d dumptest" <<'EOF'
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');
EOF
    CHECK_RESULT $?

    su - opengauss -c 'gsql -d dumptest -c "SELECT * FROM users;"' | grep "3 rows"
    CHECK_RESULT $?

    su - opengauss -c "gs_dump dumptest -f /tmp/dumptest.db --format d"| grep "dump database dumptest successfully"
    CHECK_RESULT $?

    su - opengauss -c 'gsql -d dumptest -c "DROP TABLE users;"' | grep "DROP TABLE"
    CHECK_RESULT $?

    su - opengauss -c "gs_restore -d dumptest /tmp/dumptest.db" | grep "restore operation successful"
    CHECK_RESULT $?

    su - opengauss -c 'gsql -d dumptest -c "SELECT * FROM users;"' | grep "3 rows"
    CHECK_RESULT $?

    su - opengauss -c 'gsql -c "DROP DATABASE dumptest;"' | grep "DROP DATABASE"
    CHECK_RESULT $?

    su - opengauss -c 'gs_restore --create -d postgres /tmp/dumptest.db' | grep "restore operation successful"
    CHECK_RESULT $?

    su - opengauss -c 'gsql -d dumptest -c "SELECT * FROM users;"' | grep "3 rows"
    CHECK_RESULT $?

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop opengauss.service
    DNF_REMOVE "$@"
    rm -rf /var/lib/opengauss/data/* /tmp/dumptest.db
    LOG_INFO "End to restore the test environment."
}

main "$@"
