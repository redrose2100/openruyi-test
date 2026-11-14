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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @modify    :   yang_lijin@qq.com
# @Date      :   2021/05/11
# @License   :   Mulan PSL v2
# @Desc      :   Verify restrict access to cron
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "cronie"
    cp -f /etc/cron.allow /etc/cron.allow-bak 2>/dev/null
    cp -f /etc/cron.deny /etc/cron.deny-bak 2>/dev/null
    grep "^testuser1:" /etc/passwd && userdel -rf testuser1
    grep "^testuser2:" /etc/passwd && userdel -rf testuser2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd testuser1
    grep "^testuser1:" /etc/passwd
    CHECK_RESULT $? 0 0 "add testuser1 failed"
    useradd testuser2
    grep "^testuser2:" /etc/passwd
    CHECK_RESULT $? 0 0 "add testuser2 failed"
    echo testuser1 >>/etc/cron.allow
    grep "^testuser1" /etc/cron.allow
    CHECK_RESULT $? 0 0 "add testuser1 to /etc/cron.allow failed"
    su - testuser1 -c "id 2>&1" | grep "testuser1"
    CHECK_RESULT $? 0 0 "su testuser1 failed"
    su - testuser1 -c "crontab -l 2>&1" | tee testlog1 | grep -qi "not allowed"
    CHECK_RESULT $? 0 1 "testuser1 not allowed to use crontab"
    su - testuser2 -c "id 2>&1" | grep "testuser2"
    CHECK_RESULT $? 0 0 "su testuser2 failed"
    su - testuser2 -c "crontab -l 2>&1" | tee testlog2 | grep -qi "not allowed"
    CHECK_RESULT $? 0 0 "testuser2 allow to use crontab"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    if [ -f /etc/cron.allow-bak ]; then
        mv -f /etc/cron.allow-bak /etc/cron.allow
    else
        rm -f /etc/cron.allow
    fi
    test -f /etc/cron.deny-bak && mv -f /etc/cron.deny-bak /etc/cron.deny
    userdel -rf testuser1
    userdel -rf testuser2
    rm -rf /run/faillock/testuser1 testlog1 testlog2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
