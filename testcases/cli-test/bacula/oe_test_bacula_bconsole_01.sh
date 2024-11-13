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
# @Desc      :   Test bconsole
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
    mkdir tmp
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    systemctl daemon-reload
    systemctl start bacula-dir.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF >tmp/1.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -D bacula-dir
    expect "OK" {send "q\n"}
    expect eof
EOF
    grep 'Enter a period to cancel a command' tmp/1.txt
    CHECK_RESULT $? 0 0 "test bconsole -D failed"
    bconsole -l | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bconsole -l failed"
    bconsole -L
    CHECK_RESULT $? 0 0 "test bconsole -L failed"
    bconsole -C DDS-4 | grep 'DDS-4'
    CHECK_RESULT $? 0 0 "test bconsole -C failed"
    expect <<EOF >tmp/2.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -c /etc/bacula/bconsole.conf
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    grep 'Enter a period to cancel a command.' tmp/2.txt
    CHECK_RESULT $? 0 0 "test bconsole -c failed"
    expect <<EOF >tmp/3.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -d 11
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    grep 'Enter a period to cancel a command.' tmp/3.txt
    CHECK_RESULT $? 0 0 "test bconsole -d failed"
    expect <<EOF >tmp/4.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -dt -d 11
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    grep '.*-.*-.* .*:.*:.* bconsole: ' tmp/4.txt
    CHECK_RESULT $? 0 0 "test bconsole -dt failed"
    expect <<EOF >tmp/5.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -n
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    grep '1000 OK:' tmp/5.txt
    CHECK_RESULT $? 0 0 "test bconsole -n failed"
    expect <<EOF >tmp/6.txt
    exp_internal 1
    set timeout -1
    spawn bconsole -s
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    grep '1000 OK' tmp/6.txt
    CHECK_RESULT $? 0 0 "test bconsole -s failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    systemctl stop bacula-dir.service
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    systemctl daemon-reload
    DNF_REMOVE
    rm -rf config/ /var/lib/mysql/* /var/spool/bacula/* tmp/
    LOG_INFO "End to restore the test environment."
}

main "$@"
