#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test bconsole
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "bacula-client mysql5-server bacula-common"
    tar -zxvf test.tar.gz
    systemctl restart mysqld
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution bacula-dir.service
    systemctl start bacula-dir.service
    expect <<EOF > /tmp/1.txt
    spawn bconsole -D bacula-dir
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/1.txt | grep 'Enter a period to cancel a command'
    CHECK_RESULT $? 0 0 "Failed option: -D"
    bconsole -l | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    bconsole -L && echo $? | grep '0'
    CHECK_RESULT $? 0 0 "Failed option: -L"
    bconsole -C DDS-4 | grep 'DDS-4'
    CHECK_RESULT $? 0 0 "Failed option: -C"
    expect <<EOF > /tmp/2.txt
    spawn bconsole -c /etc/bacula/bconsole.conf
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/2.txt | grep 'Enter a period to cancel a command.'
    CHECK_RESULT $? 0 0 "Failed option: -c"
    expect <<EOF > /tmp/3.txt
    spawn bconsole -d 11
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/3.txt | grep 'Enter a period to cancel a command.'
    CHECK_RESULT $? 0 0 "Failed option: -d"
    expect <<EOF > /tmp/4.txt
    spawn bconsole -dt -d 11
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/4.txt | grep '.*-.*-.* .*:.*:.* bconsole: '
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    expect <<EOF > /tmp/5.txt
    spawn bconsole -n
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/5.txt | grep '1000 OK:'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    expect <<EOF > /tmp/6.txt
    spawn bconsole -s
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/6.txt | grep '1000 OK'
    CHECK_RESULT $? 0 0 "Failed option: -s"
    expect <<EOF > /tmp/7.txt
    spawn bconsole -u 30
    expect "Enter a period to cancel a command." {send "q\n"}
EOF
    cat /tmp/7.txt | grep '1000 OK'
    CHECK_RESULT $? 0 0 "Failed option: -u"
    bconsole -t && echo $? | grep '0'
    CHECK_RESULT $? 0 0 "Failed option: -t"
    bconsole -? 2>&1 | grep 'Usage: '
    CHECK_RESULT $? 0 0 "Failed option: -?"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop bacula-dir.service
    sed -i 's\dbuser = "root"\dbuser = "bacula"\g' /etc/bacula/bacula-dir.conf
    alternatives --set libbaccats.so /usr/lib64/libbaccats-postgresql.so
    /usr/libexec/bacula/drop_mysql_tables
    /usr/libexec/bacula/drop_mysql_database
    systemctl stop mysqld
    DNF_REMOVE
    rm -rf config/ /var/lib/mysql/* /tmp/*.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
