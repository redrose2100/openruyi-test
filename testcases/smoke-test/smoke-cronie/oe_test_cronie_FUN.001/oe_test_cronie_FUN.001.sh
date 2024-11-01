#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   xieshouhang 
# @Contact   :   1069178568@qq.com
# @Date      :   2024/10/30
# @Desc      :   user identity authentication sm test
# ##################################
# shellcheck disable=SC2002,SC2119


source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cronie
    systemctl status crond.service || systemctl restart crond.service
    if [ -e "$CRONPATH" ]; then
        flag=1
        cp -ar "$CRONPATH" /var/spool/cron/root.bak
    fi
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    crontab -n local
    CHECK_RESULT $? 0 0 
    crontab -c | grep local
    CHECK_RESULT $? 0 0
    crontab -s cron_task
    cat "$CRONPATH" | grep -E "MLS_LEVEL|SELINUX_ROLE_TYPE"
    CHECK_RESULT $? 0 0
    echo n | crontab -i -r
    crontab -l | grep "test_long.sh"
    CHECK_RESULT $? 0 0
    echo y | crontab -i -r
    crontab -l | grep "test_long.sh"
    CHECK_RESULT $? 0 0 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    DNF_REMOVE "$@"
    if [ $flag == 1 ]; then
        mv /var/spool/cron/root.bak "$CRONPATH"
    fi
    LOG_INFO "End to clean the test environment."
}

main "$@"

