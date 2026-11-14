#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   least length of passwd
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=${LANG}
    export LANG=en_US.UTF-8
    sed -i 's/password    requisite     pam_pwquality.so try_first_pass local_users_only/password    requisite     pam_pwquality.so minlen=8 minclass=3 enforce_for_root try_first_pass local_users_only retry=3 dcredit=0 ucredit=0 lcredit=0 ocredit=0\npassword    required      pam_pwhistory.so use_authtok remember=5 enforce_for_root/g' /etc/pam.d/system-auth
    # sed -i 's/password    required      pam_deny.so/password    required      pam_deny.so minlen=8 enforce_for_root try_first_pass local_users_only retry=3/g' /etc/pam.d/system-auth
    useradd test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 原脚本连续三段 "expect \"*assword:\""：但 "BAD PASSWORD:" 本身就含有子串
    # "ASSWORD:"，"*assword:" 会命中告警行而不是提示行，导致密码错位、必然
    # "Sorry, passwords do not match."。这里改成按完整提示串匹配，并拆成两轮：
    # 第一轮用短密码，只校验 pam_pwquality 给出了 BAD PASSWORD 告警；
    # 第二轮用合规密码，校验修改成功。
    expect <<EOF1
    log_file testlog
    set timeout 60
    spawn passwd test
    expect "New password:"
    send "123\\r"
    expect {
        "BAD PASSWORD" { exp_continue }
        "Retype new password:" { send "123\\r" }
    }
    expect eof
EOF1
    grep -e "BAD PASSWORD" testlog
    CHECK_RESULT $? 0 0 "pam_pwquality did not reject the short password"
    expect <<EOF2
    log_file -a testlog
    set timeout 60
    spawn passwd test
    expect "New password:"
    send "Administrator12#$\\r"
    expect "Retype new password:"
    send "Administrator12#$\\r"
    expect eof
EOF2
    grep -e "passwd: all authentication tokens updated successfully" testlog
    CHECK_RESULT $? 0 0 "grep failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # sed 's/password    required      pam_deny.so minlen=8 enforce_for_root try_first_pass local_users_only retry=3/password    required      pam_deny.so/g' /etc/pam.d/system-auth
    sed -i 's/password    requisite     pam_pwquality.so minlen=8 minclass=3 enforce_for_root try_first_pass local_users_only retry=3 dcredit=0 ucredit=0 lcredit=0 ocredit=0/password    requisite     pam_pwquality.so try_first_pass local_users_only/g' /etc/pam.d/system-auth
    sed -i '/password    required      pam_pwhistory.so use_authtok remember=5 enforce_for_root/d' /etc/pam.d/system-auth
    rm -rf testlog
    userdel -rf test
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
