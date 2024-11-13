#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test bacula-dir
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    if yum list | grep -q "mysql5-server"; then
        DNF_INSTALL "bacula-client mysql5-server bacula-common"
    else
        DNF_INSTALL "bacula-client mysql-server bacula-common"
    fi
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup bacula-dir -d -v -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -c -d -v failed"
    pkill -f bacula-.*
    bacula-dir -v -dt -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -dt failed"
    pkill -f bacula-.*
    (timeout 6 bacula-dir -v -f -s -c /etc/bacula/bacula-dir.conf) &
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -f -s failed"
    pkill -f bacula-.*
    bacula-dir -v -g root -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -g failed"
    pkill -f bacula-.*
    bacula-dir -v -u root -P -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -P failed"
    pkill -f bacula-.*
    bacula-dir -v -u root -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -u failed"
    pkill -f bacula-.*
    bacula-dir -v -m -c /etc/bacula/bacula-dir.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-dir
    CHECK_RESULT $? 0 0 "test bacula-dir -m failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    pkill -f bacula-.*
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    rm -rf ./*.log bacula-dir.trace var/lib/mysql/* /var/spool/bacula/*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
