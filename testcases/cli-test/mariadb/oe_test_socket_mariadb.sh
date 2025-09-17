#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/09/16
# @License   :   Mulan PSL v2
# @Desc      :   Test mariadb.socket restart
# #############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL mariadb-server
    if rpm -ql mariadb-server | grep -q "mariadb.socket"; then
        LOG_INFO "mariadb.socket exists"
    else
        LOG_INFO "mariadb.socket is not exist"
        exit 255
    fi
    setenforce 0
    systemctl stop mariadb.service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution mariadb.socket
    test_reload mariadb.socket
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop mariadb.socket
    DNF_REMOVE "$@"
    setenforce 1
    rm -rf /var/lib/mysql/*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
