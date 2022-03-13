#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Date      :   2022-02-20
# @License   :   Mulan PSL v2
# @Desc      :   set_user_special_right
# ############################################

source ./common/lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    postgresql_install

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - postgres -c "psql -c \"select * from pg_roles;\""
    CHECK_RESULT $?
    expect <<-END
    spawn su - postgres -c "psql -d template1"
    expect "template1=#"
    send "CREATE GROUP sale;\n"
    send "create user sale1;\n"
    send "create role sale2;\n"
    send "create user sale3;\n"
    send "ALTER GROUP sale ADD USER sale1,sale2,sale3;\n"
    send "\\\du\n"
    send "create table employee(myid int, myname varchar(256), primary key(myid));\n"
    send "create table products(pid int, pname varchar(256), primary key(pid));\n"
    send "GRANT SELECT ON employee,products TO GROUP sale;\n"
    send "ALTER GROUP sale DROP USER sale2;\n"
    send "drop table employee;\n"
    send "drop table products;\n"
    send "drop user sale1;\n"
    send "drop user sale2;\n"
    send "drop user sale3;\n"
    send "drop group sale;\n"
    send "\\\q\n"
    expect eof
END
    exit
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop postgresql
    DNF_REMOVE
    rm -rf /var/lib/pgsql/*
    LOG_INFO "End to restore the test environment."
}
main "$@"
