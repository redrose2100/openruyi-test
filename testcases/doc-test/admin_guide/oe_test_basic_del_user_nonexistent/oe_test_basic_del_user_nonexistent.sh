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
# @Author    :   OpenCode
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   Verify deleting a nonexistent user is rejected
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    user=testuser_not_exist_case
    getent passwd "${user}" >/dev/null 2>&1 && userdel -r "${user}" >/dev/null 2>&1
    getent group "${user}" >/dev/null 2>&1 && groupdel "${user}" >/dev/null 2>&1
    rm -rf del_nonexistent.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    userdel -r "${user}" >del_nonexistent.log 2>&1
    CHECK_RESULT $? 0 1
    getent passwd "${user}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1
    test -d "/home/${user}"
    CHECK_RESULT $? 0 1
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    getent passwd "${user}" >/dev/null 2>&1 && userdel -r "${user}" >/dev/null 2>&1
    getent group "${user}" >/dev/null 2>&1 && groupdel "${user}" >/dev/null 2>&1
    rm -rf del_nonexistent.log
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
