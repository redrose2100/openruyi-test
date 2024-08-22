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
# @Desc      :   Test bacula-sd
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client mysql-server bacula-common"
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup bacula-sd -v -dt -d 21 -c /etc/bacula/bacula-sd.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -c -v -d -dt failed"
    pkill -f bacula-sd
    (timeout 5 bacula-sd -v -f -s -c /etc/bacula/bacula-sd.conf)&
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -f -s failed"
    pkill -f bacula-sd
    bacula-sd -v -g root -c /etc/bacula/bacula-sd.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -g failed"
    pkill -f bacula-sd
    bacula-sd -v -u root -P -c /etc/bacula/bacula-sd.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -P failed"
    pkill -f bacula-sd
    bacula-sd -v -u root -c /etc/bacula/bacula-sd.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -u failed"
    pkill -f bacula-sd
    bacula-sd -v -m -c /etc/bacula/bacula-sd.conf
    SLEEP_WAIT 3
    ss -ntlp | grep bacula-sd
    CHECK_RESULT $? 0 0 "test bacula-sd -m failed"
    pkill -f bacula-sd
    bacula-sd -v -T -c /etc/bacula/bacula-sd.conf
    CHECK_RESULT $? 0 0 "test bacula-sd -T failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    pkill -f bacula-sd
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    rm -rf *.log bacula-sd.trace  var/lib/mysql/* /var/spool/bacula/*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
