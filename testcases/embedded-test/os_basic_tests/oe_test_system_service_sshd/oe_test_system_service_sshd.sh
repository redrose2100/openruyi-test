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
# @Date      :   2020-4-10
# @License   :   Mulan PSL v2
# @Desc      :   Restart and stop the OpenSSH service repeatedly
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."

    for ((i = 1; i < 10; i ++)); do
        # 如果不是systemd文件管理系统，执行额外的停止和启动检查
        if ! command -v systemctl &>/dev/null; then
            /etc/init.d/sshd stop
            CHECK_RESULT $? 0 0 "stop sshd fail"
            /etc/init.d/sshd start
            CHECK_RESULT $? 0 0 "start sshd fail"
            SLEEP_WAIT 2
            /etc/init.d/sshd restart
            CHECK_RESULT $? 0 0 "restart sshd fail"
            SLEEP_WAIT 2
        else
            systemctl stop sshd
            CHECK_RESULT $? 0 0 "stop sshd fail"
            systemctl start sshd
            CHECK_RESULT $? 0 0 "start sshd fail"
            SLEEP_WAIT 2
            systemctl restart sshd
            CHECK_RESULT $? 0 0 "restart sshd fail"
            SLEEP_WAIT 2
        fi
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    # 如果不是systemd文件管理系统，执行额外的重启检查
    if ! command -v systemctl &>/dev/null; then
        /etc/init.d/sshd restart
        CHECK_RESULT $? 0 0 "restart sshd fail"
    else
        systemctl restart sshd
        CHECK_RESULT $? 0 0 "restart sshd fail"
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
