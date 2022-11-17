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
# @Desc      :   Test bsdjson
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
    expect <<EOF > /tmp/1.txt
    spawn dbcheck -v -B -C MyCatalog -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/1.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -v"
    expect <<EOF > /tmp/2.txt
    spawn dbcheck -v -B -C MyCatalog -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/2.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -B"
    expect <<EOF > /tmp/3.txt
    spawn dbcheck -v -B -C MyCatalog -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/3.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -C"
    expect <<EOF > /tmp/4.txt
    spawn dbcheck -v -B -C MyCatalog -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/4.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -d"
    expect <<EOF > /tmp/5.txt
    spawn dbcheck -v -B -C MyCatalog -dt -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/5.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    expect <<EOF > /tmp/6.txt
    spawn dbcheck -f -v -B -C MyCatalog -dt -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    cat /tmp/6.txt | grep 'Verbose is '
    CHECK_RESULT $? 0 0 "Failed option: -f"
    dbcheck -c /etc/bacula/bacula-dir.conf -f -v -B -C MyCatalog -dt -d 11 /home/back_1 bacula root ""  127.0.0.1  3306 ssh 2>&1| grep 'db_name=bacula'
    CHECK_RESULT $? 0 0 "Failed option: -c"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf config/ /tmp/*.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
