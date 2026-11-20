#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.3.31
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-authselect
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# openEuler 的 authselect 默认 profile 为 minimal/nis，openRuyi 只为
# local/openruyi-local/sssd/winbind，因此不写死 minimal，先查询实际可用的 profile。
pick_profile() {
    for _p in minimal local openruyi-local nis sssd winbind; do
        if authselect list 2>/dev/null | awk '{print $2}' | grep -qx "${_p}"; then
            echo "${_p}"
            return 0
        fi
    done
    return 1
}

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL authselect
    lang="$LANG"
    LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    profile=$(pick_profile)
    if [ -z "${profile}" ]; then
        LOG_WARN "No usable authselect profile found, skip the test."
        return 0
    fi
    authselect select ${profile} --force
    CHECK_RESULT $? 0 0 "Select failure"
    back_up=$(authselect backup-list 2>/dev/null | tail -n 1 | awk '{print $1}')
    if [ -z "${back_up}" ]; then
        LOG_WARN "authselect created no backup, skip the backup operations."
        return 0
    fi
    authselect check | grep "Current configuration is valid"
    CHECK_RESULT $? 0 0 "Validity failure"
    authselect backup-restore "$back_up"
    CHECK_RESULT $? 0 0 "Recovery failure"
    authselect backup-remove "$back_up"
    CHECK_RESULT $? 0 0 "remove failure"
    authselect backup-list | grep "$back_up"
    CHECK_RESULT $? 0 1 "delete failure"
}

function post_test() {
    DNF_REMOVE "$@"
    LANG=$lang
}

main "$@"

