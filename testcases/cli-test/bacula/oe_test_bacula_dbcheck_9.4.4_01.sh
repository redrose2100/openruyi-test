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
# @Desc      :   Test dbcheck
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"


# 判断 bacula 版本是否为9.4.4, 如果不是skip退出 
checkversion944() {
    BACULA_VERSION=$(yum info bacula-common 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    REQUIRED_VERSION=9.4.4
    if [[ "$BACULA_VERSION" != "$REQUIRED_VERSION" ]]; then
        echo "当前仓库 bacula 版本为 ${BACULA_VERSION}，不等于${REQUIRED_VERSION}，跳过测试"
        exit 255
    fi
}


function pre_test() {
    checkversion944
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
    mkdir tmp
    /usr/libexec/bacula/create_mysql_database
    /usr/libexec/bacula/make_mysql_tables
    alternatives --set libbaccats.so /usr/lib64/libbaccats-mysql.so
    sed -i 's\dbuser = "bacula"\dbuser = "root"\g' /etc/bacula/bacula-dir.conf
    systemctl start bacula-dir.service bacula-sd.service bacula-fd.service
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF >tmp/4.txt
    spawn dbcheck -v -B -C MyCatalog -d 11 tmp/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    grep 'Verbose is ' tmp/4.txt
    CHECK_RESULT $? 0 0 "test dbcheck -v -B -C -d failed"
    expect <<EOF >tmp/5.txt
    spawn dbcheck -v -B -C MyCatalog -dt -d 11 tmp/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    grep 'Verbose is ' tmp/5.txt
    CHECK_RESULT $? 0 0 "test dbcheck -dt failed"
    expect <<EOF >tmp/6.txt
    spawn dbcheck -f -v -B -C MyCatalog -dt -d 11 tmp/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    grep 'Verbose is ' tmp/6.txt
    CHECK_RESULT $? 0 0 "test dbcheck -f failed"
    expect <<EOF >tmp/7.txt
    spawn dbcheck -b -v -d 21 tmp/back_1 bacula root ""  127.0.0.1  3306 ssh
    expect "Please select the function you want to perform." {send "1\n"}
    expect "Select function number:" {send "18\n"}
EOF
    grep 'Found 0 bad Path records.' tmp/7.txt
    CHECK_RESULT $? 0 0 "test dbcheck -b failed"
    dbcheck -c /etc/bacula/bacula-dir.conf -f -v -B -C MyCatalog -dt -d 11 tmp/back_1 bacula root "" 127.0.0.1 3306 ssh 2>&1 | grep 'db_name=bacula'
    CHECK_RESULT $? 0 0 "test dbcheck -c failed"
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
    DNF_REMOVE "$@"
    rm -rf config/ tmp/ /var/lib/mysql/* /var/spool/bacula/*
    LOG_INFO "End to restore the test environment."
}


main "$@"

