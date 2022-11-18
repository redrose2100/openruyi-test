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
# @Desc      :   Test strongswan.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL strongswan
}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Start testing charon-systemd"
    charon-systemd &
    CHECK_RESULT $?
    ps -ef|grep "charon-systemd"|grep -v ".sh"|grep -v grep
    CHECK_RESULT $?

}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    ps -ef|grep "charon-systemd"|grep -v ".sh"|grep -v grep|awk {'print $2'}|xargs kill -9
    CHECK_RESULT $?
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

