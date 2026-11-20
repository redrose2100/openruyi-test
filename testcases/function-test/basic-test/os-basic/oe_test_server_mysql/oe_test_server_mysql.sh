#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   mysql restarts repeatedly
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# openRuyi 仓库无 mysql 包，仅有 mariadb（提供 mysqld/mysql 命令与
# mariadb.service，且 Alias=mysql.service，可直接用 systemctl 管理）。
# 首次 systemctl start 时 mariadb.service 会通过 mysql-systemd-helper
# 自动初始化 datadir，因此无需手工执行 mysqld --initialize。
function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "mariadb mariadb-client procps"
    CHECK_RESULT $?
    rpm -qa | grep -iE "mariadb"
    CHECK_RESULT $?
    if command -v mysqld >/dev/null 2>&1; then
        systemctl start mariadb
        CHECK_RESULT $?
        servername=mariadb
    else
        LOG_ERROR "mysqld not found after installing mariadb"
        exit 1
    fi
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    for mysql_count in $(seq 1 10); do
        systemctl start ${servername}
        CHECK_RESULT $?
        systemctl status ${servername} | grep -wE 'running|active'
        CHECK_RESULT $?

        systemctl restart ${servername}
        CHECK_RESULT $?

        systemctl stop ${servername}
        CHECK_RESULT $?
        systemctl disable ${servername}
        CHECK_RESULT $?
        SLEEP_WAIT 2
    done
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl disable mariadb 2>/dev/null || true
    systemctl stop mariadb 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@
