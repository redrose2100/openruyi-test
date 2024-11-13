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
# @Desc      :   Test bscan
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    if yum list | grep -q "mysql5-server"; then
        DNF_INSTALL "bacula-client mysql5-server bacula-common tar"
    else
        DNF_INSTALL "bacula-client mysql-server bacula-common tar"
    fi
    tar -zxvf common/test.tar.gz
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    systemctl start bacula-dir.service bacula-sd.service bacula-fd.service
    expect <<EOF
    exp_internal 1
    set timeout -1
    spawn bconsole
    expect "Enter a period to cancel a command." {send "mount\n"}
    expect "Select Storage resource" {send "1\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter autochanger slot"  {send "\n"}
    expect "always mounted"  {send "create\n"}
    expect "Select Pool resource" {send "1\n"}
    expect "created" {send "create\n"}
    expect "Select Pool resource" {send "2\n"}
    expect "created" {send "q\n"}
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF
    exp_internal 1
    set timeout -1
    spawn bconsole
    expect "Enter a period to cancel a command." {send "label\n"}
    expect "Select Storage resource (1-2):" {send "1\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter new Volume name:" {send "tests1\n"}
    expect "Enter slot (0 or Enter for none):" {send "0\n"}
    expect "Defined Pools:" {send "1\n"}
    expect "successfully created" {send "q\n"}
EOF
    bscan -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bscan -? failed"
    bscan FileChgr1-Dev1 -V tests1 -n bacula -u root -P "" -h localhost -t 3306 | grep 'Records would have been added or updated in the catalog'
    CHECK_RESULT $? 0 0 "test bscan -V -n -u -P -h -t failed"
    bscan -r FileChgr1-Dev1 -V tests1 -n bacula -u root -P "" -h localhost -t 3306 | grep 'Record: '
    CHECK_RESULT $? 0 0 "test bscan -r failed"
    bscan -v -s FileChgr1-Dev1 -V tests1 -n bacula -u root -P "" -h localhost -t 3306 | grep 'Using Database: bacula, User: root'
    CHECK_RESULT $? 0 0 "test bscan -s -v -S failed"
    bscan -v -w /tmp FileChgr1-Dev1 -V tests1 -n bacula -u root -P "" -h localhost -t 3306 | grep 'Ready to read from volume "tests1" on File device "FileChgr1-Dev1" (/tmp).'
    CHECK_RESULT $? 0 0 "test bscan -w failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    systemctl stop bacula-dir.service bacula-sd.service bacula-fd.service
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    rm -rf config/ /var/lib/mysql/* /tmp/test* /var/spool/bacula/*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
