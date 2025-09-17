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
# @Desc      :   Test mariadb.service restart
# #############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL mariadb-server
    mv /etc/my.cnf /etc/my.bak
    log_time="$(date '+%Y-%m-%d %T')"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_restart mariadb.service
    test_enabled mariadb.service
    journalctl --since "${log_time}" -u mariadb.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|create_uring failed: falling back to libaio"
    CHECK_RESULT $? 0 1 "There is an error message for the log of mariadb.service"
    test_reload mariadb.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop mariadb.service
    mv /etc/my.bak /etc/my.cnf
    DNF_REMOVE "$@"
    rm -rf /var/lib/mysql/*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
