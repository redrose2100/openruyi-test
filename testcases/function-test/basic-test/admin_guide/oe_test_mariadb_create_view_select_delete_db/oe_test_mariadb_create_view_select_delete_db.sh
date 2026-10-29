#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   Create, view, select, delete database
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    # firewalld only needs to be down for the duration of this run;
    # post_test restores the original state recorded here.
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    ORIG_SELINUX_MODE=$(getenforce 2>/dev/null)
    systemctl stop firewalld
    
    setenforce 0
    groupadd mysql
    useradd -g mysql mysql
    echo "${NODE1_PASSWORD}" | passwd --stdin mysql
    test -d /data || mkdir data
    test -d /data/mariadb || mkdir -p /data/mariadb
    cd /data/mariadb || exit
    mkdir data tmp run log
    chown -R mysql:mysql /data
    chown -R mysql:mysql /var/log/mariadb/
    cd - || exit
    rm -rf /var/lib/mysql/*
    DNF_INSTALL mariadb-server
    systemctl start mariadb
    SLEEP_WAIT 3
    mysqladmin -uroot password "${NODE1_PASSWORD}"
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect -c "
    set timeout 10
    log_file testlog
    spawn mysql -u root -p
    expect {
        \"Enter*\" { send \"${NODE1_PASSWORD}\r\";
        expect \"Maria*\" { send \"CREATE DATABASE databaseexample;\r\"}
        expect \"Maria*\" { send \"SHOW DATABASES;\r\"}
        expect \"Maria*\" { send \"USE databaseexample;\r\"}
        expect \"Maria*\" { send \"DROP DATABASE databaseexample;\r\"}
        expect \"Maria*\" { send \"SHOW DATABASES;\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
    "
    grep -v changed testlog | grep -w "Database" -A 5 | grep -w databaseexample
    CHECK_RESULT $?
    grep "USE databaseexample" -A 2 testlog | grep "Database changed"
    CHECK_RESULT $?
    CHECK_RESULT "$(grep -v changed testlog | grep -w "Database" -A 5 | grep -wc databaseexample)" 1
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    case "${ORIG_SELINUX_MODE:-}" in
    Enforcing) setenforce 1 ;;
    Permissive) setenforce 0 ;;
    *) LOG_WARN "Original selinux mode unknown, skip selinux restore." ;;
    esac
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
    DNF_REMOVE "$@"
    userdel -rf mysql
    groupdel mysql
    rm -rf testlog data tmp run log
    LOG_INFO "Finish environment cleanup."
}

main "$@"
