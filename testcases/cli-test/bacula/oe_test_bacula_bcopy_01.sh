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
# @Desc      :   Test bcopy
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client bacula-common mysql-server tar"
    tar -zxvf common/test.tar.gz 
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    systemctl start bacula-dir.service bacula-fd.service bacula-sd.service
    mt -f /dev/nst0 rewind
    tar cvf /dev/nst0 .
    mt -f /dev/nst0 rewind
    tar tvf /dev/nst0
    expect <<EOF
    exp_internal 1
    set timeout -1
    spawn bconsole
    expect "Enter a period to cancel a command." {send "mount\n"}
    expect "Select Storage resource" {send "1\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter autochanger slot"  {send "\n"}
    expect "always mounted"  {send "q\n"}
EOF
    expect <<EOF
    exp_internal 1
    set timeout -1
    spawn bconsole
    expect "Enter a period to cancel a command." {send "mount\n"}
    expect "Select Storage resource" {send "2\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter autochanger slot"  {send "\n"}
    expect "always mounted"  {send "create\n"}
    expect "Select Pool resource" {send "1\n"}
    expect "created" {send "create\n"}
    expect "Select Pool resource" {send "2\n"}
    expect "created" {send "q\n"}
EOF
    expect <<EOF
    spawn bconsole
    exp_internal 1
    set timeout -1
    expect "Enter a period to cancel a command." {send "label\n"}
    expect "Select Storage resource" {send "1\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter new Volume name"  {send "testc1\n"}
    expect "Enter slot"  {send "0\n"}
    expect "Select the Pool"  {send "1\n"}
    expect "always mounted"  {send "label\n"}
    expect "Select Storage resource" {send "2\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter new Volume name"  {send "test2\n"}
    expect "Enter slot"  {send "0\n"}
    expect "Select the Pool"  {send "1\n"}
    expect "always mounted"  {send "q\n"}
EOF
    echo 'Device {
  Name = Onstream
  Media Type = "DDS-4"
  Archive Device = /dev/nst0
  LabelMedia = yes;                   # lets Bacula label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
  Maximum Concurrent Jobs = 5

}' >> /etc/bacula/bacula-sd.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    bcopy -b ./config/2.conf -i testc1 FileChgr1-Dev1 -o testdev Onstream | grep 'Using device: "FileChgr1-Dev1" for reading.'
    CHECK_RESULT $? 0 0 "test bcopy -b failed"
    bcopy -c /etc/bacula/bacula-sd.conf -i testc1 FileChgr1-Dev1 -o test2 Onstream | grep 'moving to end of data.'
    CHECK_RESULT $? 0 0 "test bcopy -c failed"
    bcopy -i testc1 FileChgr1-Dev1 -o test2 Onstream | grep 'moving to end of data.'
    CHECK_RESULT $? 0 0 "test bcopy -i -o failed"
    bcopy -d 20 -i testc1 FileChgr1-Dev1 -o test2 Onstream  | grep 'bcopy: address_conf.c:.* Initaddr'
    CHECK_RESULT $? 0 0 "test bcopy -d failed"
    bcopy -dt -i testc1 FileChgr1-Dev1 -o test2 Onstream  | grep '.*-.*-.* .*:.*:.* bcopy: '
    CHECK_RESULT $? 0 0 "test bcopy -dt failed"
    bcopy -p -i testc1 FileChgr1-Dev1 -o test2 Onstream | grep 'moving to end of data.'
    CHECK_RESULT $? 0 0 "test bcopy -p failed"
    bcopy -w /tmp -i testc1 FileChgr1-Dev1 -o test2 Onstream | grep 'moving to end of data.'
    CHECK_RESULT $? 0 0 "test bcopy -w failed"
    bcopy -v -i testc1 FileChgr1-Dev1 -o test2 Onstream | grep 'moving to end of data.'
    CHECK_RESULT $? 0 0 "test bcopy -v failed"
    bcopy -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bcopy -? failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    systemctl stop bacula-dir.service bacula-fd.service bacula-sd.service
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    rm -rf config/ /var/lib/mysql/* /tmp/test* /dev/nst0 /var/spool/bacula/*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
