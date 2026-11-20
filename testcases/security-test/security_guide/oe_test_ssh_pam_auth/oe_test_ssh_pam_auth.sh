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
# @Modify    :   yang_lijin@qq.com
# @Date      :   2021/7/22
# @License   :   Mulan PSL v2
# @Desc      :   Login authentication with PAM
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
# A password that satisfies the default pwquality policy.
TEST_PASSWORD="Oetest1@Sec23"

# "UsePAM yes" may live in an Include'd drop-in (/etc/ssh/sshd_config.d/*.conf)
# instead of /etc/ssh/sshd_config, so the effective configuration reported by
# "sshd -T" is the primary source; the raw files are only a fallback for the
# case where "sshd -T" cannot be executed.
function usepam_enabled() {
    if sshd -T 2>/dev/null | grep -qiE '^usepam[[:space:]]+yes'; then
        return 0
    fi
    grep -rqiE '^[[:space:]]*UsePAM[[:space:]]+yes' /etc/ssh/sshd_config \
        /etc/ssh/sshd_config.d/ 2>/dev/null
    return $?
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep -q "^testuser:" /etc/passwd && userdel -rf testuser
    # Report only; the assertion is made in run_test.
    if usepam_enabled; then
        LOG_INFO "PAM authentication is enabled in the effective sshd configuration."
    else
        LOG_WARN "UsePAM is not enabled in the effective sshd configuration."
    fi
    # openRuyi ships pam_lastlog2.so (sqlite backed) instead of pam_lastlog.so,
    # and pam_lastlog2 has no showfailed option, so the "Last failed login"
    # banner is not printable; the failed attempt is verified from the log
    # sources instead of from a PAM banner.
    if ls /usr/lib64/security/pam_lastlog*.so /usr/lib/security/pam_lastlog*.so \
        /lib64/security/pam_lastlog*.so /lib/security/pam_lastlog*.so >/dev/null 2>&1; then
        LOG_INFO "A pam_lastlog module is available for login accounting."
    else
        LOG_WARN "No pam_lastlog module is shipped in this release."
    fi
    systemctl restart sshd
    SLEEP_WAIT 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    usepam_enabled
    CHECK_RESULT $? 0 0 "PAM authentication is not enabled in the effective sshd configuration"
    useradd testuser
    expect <<EOF
        set timeout 30
        spawn passwd testuser
        expect {
            "*assword*" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    expect <<EOF1
        log_file testlog
        set timeout 15
        spawn ssh -o StrictHostKeyChecking=no testuser@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "password:" {
                send "test\\r"
                exp_continue
            }
            eof
        }
EOF1
    # PAM authentication must reject the wrong password.
    grep -q "Permission denied" testlog
    CHECK_RESULT $? 0 0 "grep 'Permission denied' failed"
    SLEEP_WAIT 2
    expect <<EOF1
        log_file testlog1
        set timeout 15
        spawn ssh -o StrictHostKeyChecking=no testuser@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "password:" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF1
    SLEEP_WAIT 5
    # openEuler writes /var/log/secure; openRuyi has no rsyslog, so failed
    # logins only reach the journal (identifier "sshd-session") and btmp.
    # Accept a record from any of the three sources.
    if grep -qiE "Failed password|authentication failure" /var/log/secure 2>/dev/null; then
        CHECK_RESULT 0 0 0 "the failed login was recorded in /var/log/secure"
    elif journalctl --since "-2min" --no-pager 2>/dev/null |
        grep -qiE "Failed password|Invalid user|authentication failure"; then
        CHECK_RESULT 0 0 0 "the failed login was recorded in the journal"
    elif lastb 2>/dev/null | grep -qi testuser; then
        CHECK_RESULT 0 0 0 "the failed login was recorded in the btmp accounting file"
    else
        CHECK_RESULT 1 0 0 "the failed login was not recorded by PAM"
    fi
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    userdel -rf testuser
    rm -f testlog testlog1
    rm -f /run/faillock/testuser 2>/dev/null
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
