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
# @Date      :   2020/05/28
# @License   :   Mulan PSL v2
# @Desc      :   Set password complexity
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # /etc/pam.d/system-auth is a symlink to /etc/authselect/system-auth on an
    # authselect based system.  Resolve the real target so that the edit and the
    # restore never replace that symlink with a regular file.
    auth_file=$(readlink -f /etc/pam.d/system-auth)
    [ -f "${auth_file}-bak" ] || cp -f "${auth_file}" "${auth_file}-bak"
    grep "^test:" /etc/passwd && userdel -rf test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    local pwq_opts="minlen=8 minclass=3 enforce_for_root try_first_pass local_users_only retry=3 dcredit=0 ucredit=0 lcredit=0 ocredit=0"
    # Rewrite any existing pam_pwquality line regardless of its original spacing/arguments.
    sed -i -E "s#^([[:space:]]*password[[:space:]]+[[:alpha:]]+[[:space:]]+pam_pwquality\.so).*#\1 ${pwq_opts}#" ${auth_file}
    grep -qE '^[[:space:]]*password[[:space:]]+[[:alpha:]]+[[:space:]]+pam_pwquality\.so' ${auth_file} ||
        echo "password    requisite     pam_pwquality.so ${pwq_opts}" >>${auth_file}
    grep -q 'pam_pwhistory\.so' ${auth_file} ||
        sed -i -E '/pam_pwquality\.so/a password    required      pam_pwhistory.so use_authtok remember=5 enforce_for_root' ${auth_file}
    grep -q 'enforce_for_root' ${auth_file}
    CHECK_RESULT $? 0 0 "configure pam_pwquality failed"
    useradd test
    passwd test <<EOF
test1
test1
EOF
    CHECK_RESULT $? 0 1 "check passwd(test1) failed"
    passwd test <<EOF
openeuler12
openeuler12
EOF
    CHECK_RESULT $? 0 1 "check passwd(openeuler12) failed"
    passwd test <<EOF
Adminstrator12#$
Adminstrator12#$
EOF
    CHECK_RESULT $? 0 0 "check passwd(Adminstrator12#$) failed"
    passwd test <<EOF
Adminstrator12#$
Adminstrator12#$
EOF
    CHECK_RESULT $? 0 1 "check passwd(Adminstrator12#$) failed"
    passwd test <<EOF
test1
test1
test1
EOF
    CHECK_RESULT $? 0 1 "check passwd(test1) failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    if [ -f "${auth_file}-bak" ]; then
        cp -f "${auth_file}-bak" "${auth_file}"
        rm -f "${auth_file}-bak"
    fi
    userdel -rf test
    echo >/etc/security/opasswd
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
