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
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022-02-20
# @License   :   Mulan PSL v2
# @Desc      :   createdb
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
    spawn su - postgres -c "psql -d template1"
    expect "template1=#"
	send "drop database mytestdb; \n"
    send "\\q\n"
    expect eof
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
