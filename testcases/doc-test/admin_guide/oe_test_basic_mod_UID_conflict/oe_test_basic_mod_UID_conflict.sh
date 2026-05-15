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
# @Desc      :   Verify conflicting UID modification is rejected
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    user_one=testuid_conflict_1
    user_two=testuid_conflict_2
    for one_user in "${user_one}" "${user_two}"; do
        getent passwd "${one_user}" >/dev/null 2>&1 && userdel -r "${one_user}" >/dev/null 2>&1
        getent group "${one_user}" >/dev/null 2>&1 && groupdel "${one_user}" >/dev/null 2>&1
    done
    rm -rf uid_conflict.log
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd "${user_one}"
    CHECK_RESULT $?
    useradd "${user_two}"
    CHECK_RESULT $?

    uid_one=$(id -u "${user_one}")
    uid_two=$(id -u "${user_two}")
    usermod -u "${uid_one}" "${user_two}" >uid_conflict.log 2>&1
    CHECK_RESULT $? 0 1
    CHECK_RESULT "$(id -u "${user_one}")" "${uid_one}"
    CHECK_RESULT "$(id -u "${user_two}")" "${uid_two}"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    for one_user in "${user_one}" "${user_two}"; do
        getent passwd "${one_user}" >/dev/null 2>&1 && userdel -r "${one_user}" >/dev/null 2>&1
        getent group "${one_user}" >/dev/null 2>&1 && groupdel "${one_user}" >/dev/null 2>&1
    done
    rm -rf uid_conflict.log
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
