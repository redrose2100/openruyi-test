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
# @Desc      :   Test btape
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
    systemctl start bacula-dir.service bacula-sd.service bacula-fd.service
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
    exp_internal 1
    set timeout -1
    spawn bconsole
    expect "Enter a period to cancel a command." {send "label\n"}
    expect "Select Storage resource" {send "1\n"}
    expect "Enter autochanger drive" {send "0\n"}
    expect "Enter new Volume name"  {send "test1\n"}
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

}' >>/etc/bacula/bacula-sd.conf
    mt -f /dev/nst0 rewind
    tar cvf /dev/nst0 .
    mt -f /dev/nst0 rewind
    tar tvf /dev/nst0
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF >tmp/1.txt
    exp_internal 1
    set timeout -1
    spawn btape -c /etc/bacula/bacula-sd.conf Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'btape: btape.c:4[0-9][0-9]-0 open device "Onstream" (/dev/nst0): OK' tmp/1.txt
    CHECK_RESULT $? 0 0 "test btape -c failed"
    expect <<EOF >tmp/2.txt
    exp_internal 1
    set timeout -1
    spawn btape -b ./config/1.conf Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'btape: btape.c:4[0-9][0-9]-0 open device "Onstream" (/dev/nst0): OK' tmp/2.txt
    CHECK_RESULT $? 0 0 "test btape -b failed"
    expect <<EOF >tmp/3.txt
    exp_internal 1
    set timeout -1
    spawn btape -d 23 Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'Initaddr ' tmp/3.txt
    CHECK_RESULT $? 0 0 "test btape -d failed"
    expect <<EOF >tmp/4.txt
    exp_internal 1
    set timeout -1
    spawn btape -dt Onstream
    expect "OK" {send "q\n"}
EOF
    grep '.*-.*-.* .*:.*:.* btape: ' tmp/4.txt
    CHECK_RESULT $? 0 0 "test btape -dt failed"
    expect <<EOF >tmp/5.txt
    exp_internal 1
    set timeout -1
    spawn btape -p Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'open device "Onstream" (/dev/nst0): OK' tmp/5.txt
    CHECK_RESULT $? 0 0 "test btape -p failed"
    expect <<EOF >tmp/6.txt
    exp_internal 1
    set timeout -1
    spawn btape -v -s Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'open device "Onstream" (/dev/nst0): OK' tmp/6.txt
    CHECK_RESULT $? 0 0 "test btape -s failed"
    expect <<EOF >tmp/7.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'open device "Onstream" (/dev/nst0): OK' tmp/7.txt
    CHECK_RESULT $? 0 0 "test btape -v failed"
    btape -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test btape -? failed"
    expect <<EOF >tmp/9.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "weof\n"}
    expect "Onstream" {send "q\n"}
EOF
    grep 'Wrote 1 EOF' tmp/9.txt
    CHECK_RESULT $? 0 0 "test btape weof failed"
    expect <<EOF >tmp/10.txt
    exp_internal 1
    set timeout -1
    spawn btape -dt -w tmp/ Onstream
    expect "OK" {send "q\n"}
EOF
    grep 'btape:' tmp/10.txt
    CHECK_RESULT $? 0 0 "test btape -w failed"
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
    rm -rf config/ /var/lib/mysql/* /tmp/test1 /tmp/test2 tmp/ /var/spool/bacula/
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
