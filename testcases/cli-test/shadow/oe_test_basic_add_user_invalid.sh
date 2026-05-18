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
# @Desc      :   Verify invalid user creation parameters are rejected
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    invalid_user_1='bad:name'
    invalid_user_2='bad/name'
    valid_name=testuser_invalid_date
    for one_user in "${invalid_user_1}" "${invalid_user_2}" "${valid_name}"; do
        getent passwd "${one_user}" >/dev/null 2>&1 && userdel -rf "${one_user}" >/dev/null 2>&1
        getent group "${one_user}" >/dev/null 2>&1 && groupdel "${one_user}" >/dev/null 2>&1
    done
    rm -rf invalid_user_1.log invalid_user_2.log invalid_date.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd "${invalid_user_1}" >invalid_user_1.log 2>&1
    CHECK_RESULT $? 0 1 "useradd should reject invalid user name ${invalid_user_1}"
    getent passwd "${invalid_user_1}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid user ${invalid_user_1} must not be created"

    useradd "${invalid_user_2}" >invalid_user_2.log 2>&1
    CHECK_RESULT $? 0 1 "useradd should reject invalid user name ${invalid_user_2}"
    getent passwd "${invalid_user_2}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid user ${invalid_user_2} must not be created"

    useradd -e 2020-13-40 "${valid_name}" >invalid_date.log 2>&1
    CHECK_RESULT $? 0 1 "useradd should reject invalid expiration date for ${valid_name}"
    getent passwd "${valid_name}" >/dev/null 2>&1
    CHECK_RESULT $? 0 1 "user ${valid_name} must not be created with invalid expiration date"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    for one_user in "${invalid_user_1}" "${invalid_user_2}" "${valid_name}"; do
        getent passwd "${one_user}" >/dev/null 2>&1 && userdel -rf "${one_user}" >/dev/null 2>&1
        getent group "${one_user}" >/dev/null 2>&1 && groupdel "${one_user}" >/dev/null 2>&1
    done
    rm -rf invalid_user_1.log invalid_user_2.log invalid_date.log
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
