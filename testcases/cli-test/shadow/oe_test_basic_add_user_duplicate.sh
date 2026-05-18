#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify duplicate user creation is rejected
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    user=testuser_dup
    getent passwd "${user}" >/dev/null 2>&1 && userdel -rf "${user}" >/dev/null 2>&1
    getent group "${user}" >/dev/null 2>&1 && groupdel "${user}" >/dev/null 2>&1
    rm -rf duplicate.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd "${user}"
    CHECK_RESULT $? 0 0 "useradd ${user} should succeed"
    CHECK_RESULT "$(grep -cE "^${user}:" /etc/passwd)" 1 0 "user ${user} should exist once in /etc/passwd"

    useradd "${user}" >duplicate.log 2>&1
    CHECK_RESULT $? 0 1 "duplicate useradd for ${user} should fail"
    CHECK_RESULT "$(grep -cE "^${user}:" /etc/passwd)" 1 0 "duplicate useradd must not create another passwd entry"
    id "${user}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "existing user ${user} should still be queryable"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    getent passwd "${user}" >/dev/null 2>&1 && userdel -rf "${user}" >/dev/null 2>&1
    getent group "${user}" >/dev/null 2>&1 && groupdel "${user}" >/dev/null 2>&1
    rm -rf duplicate.log
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
