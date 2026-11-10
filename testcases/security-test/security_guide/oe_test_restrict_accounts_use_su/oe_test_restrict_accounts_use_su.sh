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
# @Author    :   yanglijin
# @Contact   :   yang_lijin@qq.com
# @Date      :   2021/03/11
# @License   :   Mulan PSL v2
# @Desc      :   restrict accounts use su
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep -q "^test1:" /etc/passwd && userdel -rf test1
    grep -q "^test2:" /etc/passwd && userdel -rf test2
    # Resolve the real target so that an authselect style symlink is not
    # replaced by a regular file when the file is edited and restored.
    su_pam=$(readlink -f /etc/pam.d/su)
    [ -f "${su_pam}-bak" ] || cp -f "${su_pam}" "${su_pam}-bak"
    # Distributions ship "auth required pam_wheel.so use_uid" commented out, so the
    # wheel-only restriction is not active by default. Enable it for this case.
    sed -i -E 's/^[#[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel\.so.*/auth            required        pam_wheel.so use_uid/' "${su_pam}"
    grep -qE '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel\.so' "${su_pam}" ||
        echo "auth            required        pam_wheel.so use_uid" >>"${su_pam}"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep -qE '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel\.so' "${su_pam}"
    CHECK_RESULT $? 0 0 "check /etc/pam.d/su failed"
    useradd test1
    echo "${NODE1_PASSWORD}" | passwd --stdin test1
    useradd test2
    echo "${NODE1_PASSWORD}" | passwd --stdin test2
    usermod -aG wheel test2
    groups test2 | grep 'wheel'
    CHECK_RESULT $? 0 0 "add test2 to group wheel failed"
    su - test1 -c "su" <<EOF
${NODE1_PASSWORD}
EOF
    CHECK_RESULT $? 0 1 "check su test1 failed"
    su - test2 -c "su" <<EOF
${NODE1_PASSWORD}
EOF
    CHECK_RESULT $? 0 0 "check su test2 failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    if [ -f "${su_pam}-bak" ]; then
        cp -f "${su_pam}-bak" "${su_pam}"
        rm -f "${su_pam}-bak"
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
