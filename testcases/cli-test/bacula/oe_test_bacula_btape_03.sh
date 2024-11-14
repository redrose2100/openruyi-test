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
    spawn btape -v Onstream
    expect "OK" {send "eom\n"}
    expect "Moved" {send "q\n"}
EOF
    grep 'Moved to end of medium' tmp/1.txt
    CHECK_RESULT $? 0 0 "test btape eom failed"
    expect <<EOF >tmp/2.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "fill\n"}
    expect "Do you want to run the simplified test" {send "s\n"}
    expect "ready" {send "\n"}
    expect ".*" {send "quit\n"}
    expect eof
EOF
    grep 'fill' tmp/2.txt
    CHECK_RESULT $? 0 0 "test btape fill failed"
    expect <<EOF >tmp/3.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "unfill\n"}
    expect ".*" {send "q\n"}
EOF
    grep 'do_unfill' tmp/3.txt
    CHECK_RESULT $? 0 0 "test btape unfill failed"
    expect <<EOF >tmp/4.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "help\n"}
    expect "Usage" {send "q\n"}
EOF
    grep 'Usage' tmp/4.txt
    CHECK_RESULT $? 0 0 "test btape help failed"
    expect <<EOF >tmp/5.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "clear\n"}
    expect "*" {send "q\n"}
EOF
    grep 'Onstream' tmp/5.txt
    CHECK_RESULT $? 0 0 "test btape clear failed"
    expect <<EOF >tmp/6.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "OK" {send "label\n"}
    expect "Enter Volume Name" {send "test1\n"}
    expect ".*" {send "q\n"}
EOF
    grep 'Wrote Volume label for volume "test1"' tmp/6.txt
    CHECK_RESULT $? 0 0 "test btape label failed"
    expect <<EOF >tmp/7.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "open device" {send "quit\n"}
EOF
    grep 'OK' tmp/7.txt
    CHECK_RESULT $? 0 0 "test btape quit failed"
    expect <<EOF >tmp/8.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "open device" {send "load\n"}
    expect ".*" {send "q\n"}
EOF
    grep 'Loaded "Onstream"' tmp/8.txt
    CHECK_RESULT $? 0 0 "test btape load failed"
    expect <<EOF >tmp/9.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "open device" {send "rawfill\n"}
    expect "Wrote 1 EOF to" {send "q\n"}
EOF
    grep 'Wrote 1 EOF to' tmp/9.txt
    CHECK_RESULT $? 0 0 "test btape rawfill failed"
    expect <<EOF >tmp/10.txt
    exp_internal 1
    set timeout -1
    spawn btape -v Onstream
    expect "open device" {send "label\n"}
    expect "Enter Volume Name" {send "test1\n"}
    expect "Wrote Volume label" {send "readlabel\n"}
    expect "Volume Label" {send "q\n"}
EOF
    grep 'Volume Label' tmp/10.txt
    CHECK_RESULT $? 0 0 "test btape readlabel failed"
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
    rm -rf config/ /var/lib/mysql/* /tmp/test1 /tmp/test2 tmp/ /var/spool/bacula/*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
