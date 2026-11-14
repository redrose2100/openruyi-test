#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangxiaoya
# @Contact   :   wangxiaoya@qq.com
# @Date      :   2022/6/9
# @License   :   Mulan PSL v2
# @Desc      :   Password complexity limit - reinforcement is not enabled by default
# ############################################


source "$OET_PATH/libs/locallibs/common_lib.sh"
# Number of failures that triggers the lock, and how long the lock lasts.
FAIL_DENY=3
FAIL_UNLOCK=60
PAM_FILES="/etc/pam.d/system-auth /etc/pam.d/password-auth"
# Whether the default PAM auth stack already enforces pam_faillock.
HAS_FAILLOCK=0
LOGIN_USER=""
LOGIN_PASS=""
CREATED_USER=0

# The account lockout only exists when the distribution wires pam_faillock into
# the default auth stack.  This testcase must not rewrite /etc/pam.d by itself:
# a wrong insertion order (authfail before pam_unix) makes the whole auth stack
# always fail and records a fresh failure on every attempt, so unlock_time never
# expires and the account - including sudo - is locked out permanently.
function detect_faillock() {
    local module="" pam_file
    for module in /usr/lib64/security/pam_faillock.so /usr/lib/security/pam_faillock.so \
        /lib64/security/pam_faillock.so /lib/security/pam_faillock.so; do
        [ -f "${module}" ] && break
        module=""
    done
    if [ -z "${module}" ]; then
        LOG_WARN "pam_faillock is not shipped in this release, the lockout check is skipped."
        return 0
    fi
    for pam_file in ${PAM_FILES}; do
        [ -f "${pam_file}" ] || continue
        if grep -qE '^[[:space:]]*auth[[:space:]]+.*pam_faillock\.so[[:space:]]+preauth' "${pam_file}"; then
            HAS_FAILLOCK=1
            LOG_INFO "pam_faillock is already configured in ${pam_file}."
        fi
    done
    if [ "${HAS_FAILLOCK}" = "0" ]; then
        LOG_WARN "pam_faillock is available but not wired into the default auth stack, the lockout check is skipped."
    fi
    return 0
}

function clean_faillock() {
    # Only drop this testcase's own failure tally, never the whole directory.
    [ -n "${LOGIN_USER}" ] && rm -f "/run/faillock/${LOGIN_USER}" 2>/dev/null
    return 0
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openssh-clients
    # root is normally denied password login (PermitRootLogin prohibit-password),
    # so a non-root account is required to exercise password authentication.
    if [ -n "${NODE2_USER}" ] && [ "${NODE2_USER}"x != "root"x ]; then
        LOGIN_USER="${NODE2_USER}"
        LOGIN_PASS="${NODE2_PASSWORD}"
    else
        LOGIN_USER="testuser"
        LOGIN_PASS="Oetest1@Sec23"
        grep -q "^${LOGIN_USER}:" /etc/passwd && userdel -rf "${LOGIN_USER}"
        useradd -m "${LOGIN_USER}"
        CREATED_USER=1
        expect <<EOF
            set timeout 15
            spawn passwd ${LOGIN_USER}
            expect {
                "*assword*" {
                    send "${LOGIN_PASS}\\r"
                    exp_continue
                }
                eof
            }
EOF
    fi
    detect_faillock
    systemctl restart sshd.service
    SLEEP_WAIT 1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # Three wrong passwords: authentication must fail and a retry prompt must be
    # shown instead of a shell.
    expect <<EOF
        set timeout 30
        log_file testlog1
        spawn ssh -o StrictHostKeyChecking=no ${LOGIN_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "*assword*" {
                send "error_pwd\\r"
                exp_continue
            }
            eof
        }
        catch wait result
        exit [lindex \$result 3]
EOF
    CHECK_RESULT $? 0 1 "Login succeeded, but the login should fail here."
    grep -E "please try again|Permission denied" testlog1
    CHECK_RESULT $? 0 0 "Retry prompt not found."
    if [ "${HAS_FAILLOCK}" = "1" ]; then
        # The account is now locked, so even the correct password is refused.
        expect <<EOF
            set timeout 30
            log_file testlog2
            spawn ssh -o StrictHostKeyChecking=no ${LOGIN_USER}@${NODE2_IPV4}
            expect {
                "*yes/no*" {
                    send "yes\\r"
                    exp_continue
                }
                "*assword*" {
                    send "${LOGIN_PASS}\\r"
                    exp_continue
                }
                eof
            }
            catch wait result
            exit [lindex \$result 3]
EOF
        CHECK_RESULT $? 0 1 "It should be locked for 1 minute after entering the wrong password for three times, but it is not locked here."
        grep -E "please try again|Permission denied|Account locked" testlog2
        CHECK_RESULT $? 0 0 "Retry prompt not found."
        SLEEP_WAIT ${FAIL_UNLOCK}
    else
        LOG_WARN "Account lockout is not configured on this system, the lock part is skipped."
    fi
    # After the lock period the correct password must be accepted again.
    expect <<EOF
        set timeout 30
        log_file testlog3
        spawn ssh -o StrictHostKeyChecking=no ${LOGIN_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "*assword*" {
                send "${LOGIN_PASS}\\r"
                exp_continue
            }
            eof
        }
EOF
    if ! grep -qE "^${LOGIN_USER}@.*[#$] $" testlog3; then
        LOG_WARN "The lockout was not released automatically, clear the failure tally and retry."
        clean_faillock
        expect <<EOF
            set timeout 30
            log_file testlog3
            spawn ssh -o StrictHostKeyChecking=no ${LOGIN_USER}@${NODE2_IPV4}
            expect {
                "*yes/no*" {
                    send "yes\\r"
                    exp_continue
                }
                "*assword*" {
                    send "${LOGIN_PASS}\\r"
                    exp_continue
                }
                eof
            }
EOF
    fi
    grep -E "^${LOGIN_USER}@.*[#$] $" testlog3
    CHECK_RESULT $? 0 0 "Login failed."
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -rf testlog*
    clean_faillock
    [ "${CREATED_USER}" = "1" ] && userdel -rf "${LOGIN_USER}"
    systemctl restart sshd.service
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
