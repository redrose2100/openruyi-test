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
# @Author    :   wenjun
# @Contact   :   1009065695@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test mysql.service restart
# #############################################

source "common/common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    service=mysqld.service
    log_time=$(date '+%Y-%m-%d %T')
    DNF_INSTALL mysql-server
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_restart "${service}"
    systemctl disable mysqld 2>&1 
    CHECK_RESULT $? 0 0 "${service} disable failed"
    systemctl enable mysqld 2>&1 | grep "Created symlink"
    CHECK_RESULT $? 0 0 "${service} enable failed"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    systemctl start "${service}"
    sed -i 's/port=3306/port=3316/' /etc/my.cnf
    systemctl daemon-reload
    systemctl restart "${service}"
    systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i 's/port=3316/port=3306/' /etc/my.cnf
    systemctl daemon-reload
    systemctl reload "${service}"
    systemctl stop "${service}"
    mysql_post
    DNF_REMOVE "$@"
    rm -rf /var/lib/mysql/*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
