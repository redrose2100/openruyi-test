#!/usr/bin/bash

# Copyright (c) 2024. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163..com
# @Date      :   2025/04/03
# @License   :   Mulan PSL v2
# @Desc      :   freetds common prepare
# #############################################
# shellcheck disable=SC2153
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function common_pre() {
    if [ "$NODE1_FRAME" == "x86_64" ]; then
        OLD_LANG=$LANG
        export LANG=en_US.UTF-8
        yum install -y policycoreutils-python-utils
        curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-2022.repo
        DNF_INSTALL "freetds mssql-server openldap openldap-devel unixODBC"
        SLEEP_WAIT 5
        echo "[egServer70]
        host = localhost
        port = 1433
        tds version = 7.3" >>/etc/freetds.conf
        expect <<EOF
        spawn /opt/mssql/bin/mssql-conf setup
        expect "*1-10*" {send "1\r"}
        expect "*Yes/No*" {send "Yes\r"}
        expect "*Enter the SQL Server*" {send "Hw123456\r"}
        expect "*Confirm the SQL Server*" {send "Hw123456\r"}
        sleep 20
        expect eof
EOF
        systemctl status mssql-server
        wget -O /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/9/prod.repo
        expect <<EOF
        spawn yum install -y mssql-tools unixODBC-devel
        expect "*YES or NO*" {send "YES\r"}
        expect "*YES or NO*" {send "YES\r"}
        expect eof
EOF
        SLEEP_WAIT 5
        OLD_PATH=$PATH
        export PATH=$PATH:/opt/mssql-tools/bin
        expect <<EOF
        spawn sqlcmd -S localhost -U sa -P Hw123456
        expect "1>" {send "CREATE DATABASE test1;\r"}
        expect "2>" {send "SELECT Name from sys.Databases;\r"}
        expect "3>" {send "GO\r"}
        expect "1>" {send "USE test1;\r"}
        expect "2>" {send "CREATE TABLE dbo.admin (\r"}
        expect "3>" {send "id INT,\r"}
        expect "4>" {send "age INT,\r"}
        expect "5>" {send "PRIMARY KEY (id)\r"}
        expect "6>" {send ");\r"}
        expect "7>" {send "GO\r"}
        expect "1>" {send "USE test1;\r"}
        expect "2>" {send "CREATE TABLE dbo.test_admin (\r"}
        expect "3>" {send "id INT,\r"}
        expect "4>" {send "age INT,\r"}
        expect "5>" {send "PRIMARY KEY (id)\r"}
        expect "6>" {send ");\r"}
        expect "7>" {send "GO\r"}
        expect "1>" {send "USE test1;\r"}
        expect "2>" {send "CREATE TABLE dbo.test_user (\r"}
        expect "3>" {send "id INT,\r"}
        expect "4>" {send "PRIMARY KEY (id)\r"}
        expect "5>" {send ");\r"}
        expect "6>" {send "GO\r"}
        expect "1>" {send "exit\r"}
        sleep 10
        expect eof
EOF
        echo "[egServer70]
Driver=FreeTDS
Description=My Data Source Description
Server=localhost
Database=test1
UID=sa
PWD=Hw123456
Port=1433
TDS_Version=7.3
Trace=ON
TraceFile=stderr" >/etc/odbc.ini
        cp -rf /etc/odbc.ini /root/.odbc.ini
    else
        LOG_INFO "Mssql server only supports x86 architecture"
        exit 1
    fi
}

function common_post() {
    expect <<EOF
    spawn sqlcmd -S localhost -U sa -P Hw123456
    expect "1>" {send "DROP DATABASE IF EXISTS test1;\r"}
    expect "2>" {send "GO\r"}
    expect "1>" {send "exit\r"}
    expect eof
EOF
    systemctl stop mssql-server
    dnf remove -y mssql-tools unixODBC-devel policycoreutils-python-utils
    DNF_REMOVE "$@"
    rm -rf /etc/yum.repos.d/msprod.repo /etc/yum.repos.d/mssql-server.repo /opt/mssql /opt/mssql-tools
    export LANG=$OLD_LANG
    export PATH=$OLD_PATH
}
