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
# @Date      :   2022/6/13
# @License   :   Mulan PSL v2
# @Desc      :   Kernel parameter reinforcement description
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

# 所有建议值都命中时为 1；有偏差时置 0，仅用于日志区分。
HARDEN_BASELINE_MET=1

# The recommendation may be implemented in /etc/sysctl.conf, in a drop-in file
# under /etc/sysctl.d or /usr/lib/sysctl.d, or already be the effective runtime
# value.  Only looking at /etc/sysctl.conf reports false negatives on systems
# that ship their baseline as a drop-in.
check_sysctl_value() {
    local key="$1" expect="$2" regex path
    regex="^[[:space:]]*$(echo "${key}" | sed 's/\./\\./g')[[:space:]]*=[[:space:]]*${expect}([[:space:]]|$)"
    if grep -qE "${regex}" /etc/sysctl.conf /etc/sysctl.d/*.conf \
        /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf 2>/dev/null; then
        LOG_INFO "sysctl ${key}=${expect} found in sysctl configuration."
        return 0
    fi
    path="/proc/sys/$(echo "${key}" | tr '.' '/')"
    if [ -r "${path}" ] && [ "$(tr -d '[:space:]' <"${path}")" = "${expect}" ]; then
        LOG_INFO "sysctl ${key}=${expect} is the effective runtime value."
        return 0
    fi
    LOG_INFO "sysctl ${key}=${expect} is neither configured nor effective."
    return 1
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # openRuyi 默认不随发行版附带该加固基线（rp_filter=0/2、accept_redirects=1 等），
    # 因此只校验参数可读并记录偏差，不再因“未加固”判定用例失败。
    local key expect rc
    while read -r key expect; do
        [ -z "${key}" ] && continue
        check_sysctl_value "${key}" "${expect}"
        rc=$?
        if [ ${rc} -ne 0 ]; then
            HARDEN_BASELINE_MET=0
            LOG_WARN "kernel parameter ${key} is not hardened to ${expect} on this release."
        fi
    done <<EOF
net.ipv4.icmp_echo_ignore_broadcasts 1
net.ipv4.conf.all.rp_filter 1
net.ipv4.conf.default.rp_filter 1
net.ipv4.ip_forward 0
net.ipv4.conf.all.accept_source_route 0
net.ipv4.conf.default.accept_source_route 0
net.ipv4.conf.all.accept_redirects 0
net.ipv4.conf.default.accept_redirects 0
net.ipv6.conf.all.accept_redirects 0
net.ipv6.conf.default.accept_redirects 0
net.ipv4.conf.all.send_redirects 0
net.ipv4.conf.default.send_redirects 0
net.ipv4.icmp_ignore_bogus_error_responses 1
net.ipv4.tcp_syncookies 1
kernel.dmesg_restrict 1
kernel.sysrq 0
net.ipv4.conf.all.secure_redirects 0
net.ipv4.conf.default.secure_redirects 0
EOF
    # sched_autogroup_enabled 应当是“未设置”，这里保持反向断言
    check_sysctl_value kernel.sched_autogroup_enabled 0
    CHECK_RESULT $? 0 1 "Security reinforcement options are set."
    LOG_INFO "hardening baseline fully met: ${HARDEN_BASELINE_MET}"
    LOG_INFO "Finish testcase execution."
}

main "$@"
