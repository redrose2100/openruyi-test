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
# @Author    :   liuyangmei
# @Contact   :   liuyangmei@h-partners.com
# @Date      :   2023/10/16
# @License   :   Mulan PSL v2
# @Desc      :   验证pavd.log的日志绕接功能
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    rpm -q secpaver || DNF_INSTALL secpaver
    systemctl is-active pavd || systemctl start pavd
}

# 测试点的执行
function run_test() {
    SLEEP_WAIT 5 "grep 'grpc server is listening' /var/log/secpaver/pavd.log"
    CHECK_RESULT "$?" 0 0 "Error in log file."

    mv /var/log/secpaver/pavd.log /var/log/secpaver/pavd.log.copy
    dd if=/dev/zero of=/var/log/secpaver/pavd.log bs=1M count=10
    systemctl restart pavd
    SLEEP_WAIT 10  "ps -ef | grep /usr/bin/pavd |grep -v grep" 1 20 1
    ls /var/log/secpaver/
    CHECK_RESULT "$?" 0 0 "Error in log dir."
    ls /var/log/secpaver/pavd-*
    CHECK_RESULT "$?" 0 0 "Error in log around."
}

# 后置处理，恢复测试环境
function post_test() {
    systemctl stop pavd
    DNF_REMOVE "$@"
    rm -rf /var/log/secpaver/pavd-* /var/log/secpaver/pavd.log
    mv /var/log/secpaver/pavd.log.copy /var/log/secpaver/pavd.log
}

main "$@"
