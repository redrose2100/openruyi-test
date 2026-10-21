#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/09/04
# @License   :   Mulan PSL v2
# @Desc      :   Test opengauss gs_ctl start/status/stop
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL opengauss
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    su - opengauss -c "gs_ctl start" |  grep 'server started'
    CHECK_RESULT $?
    su - opengauss -c "gs_ctl status" | grep 'server is running'
    CHECK_RESULT $?
    su - opengauss -c "gs_ctl query"
    CHECK_RESULT $?
    su - opengauss -c "gs_ctl stop" | grep 'server stopped'
    CHECK_RESULT $?

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /var/lib/opengauss/data/*
    LOG_INFO "End to restore the test environment."
}

main "$@"
