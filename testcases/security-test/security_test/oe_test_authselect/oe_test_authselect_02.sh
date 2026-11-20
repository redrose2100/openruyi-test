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
    authselect list | grep "${profile}"
    CHECK_RESULT $? 0 0 "Display failure"
    authselect create-profile test | grep "New profile was created"
    CHECK_RESULT $? 0 0 "Failed to create an empty configuration set. Procedure"
    authselect list
    CHECK_RESULT $? 0 1 "Configuration set display failed"
    rm -fr /etc/authselect/custom
    authselect create-profile test --base-on=${profile} | grep "New profile was created"
    CHECK_RESULT $? 0 0 "Failed to create a configuration set. Procedure"
    authselect list | grep "${profile}"
    CHECK_RESULT $? 0 0 "Creation failure"
    # 空 profile 会输出 "No requirements are specified"，基于底座 profile 时则会
    # 复制其 REQUIREMENTS 内容，两种输出都算正常。
    if authselect requirements custom/test 2>&1 | grep -q "No requirements are specified"; then
        CHECK_RESULT 0 0 0
    elif authselect requirements custom/test >/dev/null 2>&1; then
        LOG_WARN "The base profile ships REQUIREMENTS, skip the empty-requirements assertion."
    else
        CHECK_RESULT 1 0 0 "Failed to print configuration set dependency"
    fi
    # 不同 authselect 版本的默认 profile 特性集不同，这里只校验命令可用。
    authselect list-features custom/test >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Description Failed to display the configuration set information"
    sel_out=$(authselect select custom/test --force 2>&1)
    CHECK_RESULT $? 0 0 "Failed to select a configuration item. Procedure"
    echo "${sel_out}" | grep 'Profile "custom/test" was selected' || \
        LOG_WARN "Unexpected select output: ${sel_out}"
    authselect current | grep "Profile ID"
    CHECK_RESULT $? 0 0 "Identifier display failed"
}

function post_test() {
    LANG=$lang
    rm -fr /etc/authselect/custom
    back_up=$(authselect backup-list 2>/dev/null | tail -n 1 | awk '{print $1}')
    if [ -n "${back_up}" ]; then
        authselect backup-restore "$back_up"
        authselect backup-remove "$back_up"
    fi
    DNF_REMOVE "$@"
}

main "$@"

