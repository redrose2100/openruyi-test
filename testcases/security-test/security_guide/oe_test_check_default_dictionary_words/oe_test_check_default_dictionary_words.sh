#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangxiaorou
#@Contact   	:   wangxiaorou@uniontech.com
#@Date      	:   2022-09-07
#@License   	:   Mulan PSL v2
#@Desc      	:   check default dictionary words for weak password
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# passwd --stdin returns 0 even when pam_pwquality rejects the password
# ("BAD PASSWORD ... Authentication token manipulation error"), so the change has
# to be verified from the command output instead of the exit status.
function check_weak_password_rejected() {
    local user=$1
    local passwd=$2
    local output
    output=$(echo "${passwd}" | passwd "${user}" --stdin 2>&1)
    LOG_INFO "passwd output: ${output}"
    echo "${output}" | grep -qiE "BAD PASSWORD|Authentication token manipulation error|password unchanged"
}

function check_password_changed() {
    local user=$1
    local passwd=$2
    local output
    output=$(echo "${passwd}" | passwd "${user}" --stdin 2>&1)
    LOG_INFO "passwd output: ${output}"
    echo "${output}" | grep -qiE "password updated successfully|passwd: password changed"
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    id normal && userdel -rf normal
    useradd normal
    # /etc/pam.d/system-auth and password-auth are symlinks to
    # /etc/authselect/* on an authselect based system.  Editing them with
    # "sed -i" would replace the symlink with a regular file, so always resolve
    # the real target first and keep the symlink itself untouched.
    local pam_file="" real_file=""
    for pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
        [ -f "${pam_file}" ] || continue
        real_file=$(readlink -f "${pam_file}")
        [ -f "${real_file}-bak" ] || cp -f "${real_file}" "${real_file}-bak"
        sed -i 's/pam_pwquality.so/pam_pwquality.so enforce_for_root/g' "${real_file}"
    done
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cracklib-unpacker /usr/share/cracklib/pw_dict | grep '!!65logan'
    CHECK_RESULT $? 0 0 "Query default dictionary words failed"
    CHECK_RESULT "$(echo '!!65logan' | cracklib-check | awk '{print $NF}')" "word" 0 "Default dictionary words check failed"
    check_weak_password_rejected normal '!!65logan'
    CHECK_RESULT $? 0 0 "Change weak password succeeded"

    cracklib-unpacker /usr/share/cracklib/pw_dict | grep 'mugen12#\$'
    CHECK_RESULT $? 0 1 "Query default dictionary words failed"
    CHECK_RESULT "$(echo 'mugen12#$' | cracklib-check | awk '{print $NF}')" "OK" 0 "Default dictionary words check failed"
    check_password_changed normal 'mugen12#$'
    CHECK_RESULT $? 0 0 "Change strong password failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    local pam_file="" real_file=""
    for pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
        [ -f "${pam_file}" ] || continue
        real_file=$(readlink -f "${pam_file}")
        if [ -f "${real_file}-bak" ]; then
            cp -f "${real_file}-bak" "${real_file}"
            rm -f "${real_file}-bak"
        fi
    done
    userdel -rf normal
    LOG_INFO "End to restore the test environment."
}

main "$@"

