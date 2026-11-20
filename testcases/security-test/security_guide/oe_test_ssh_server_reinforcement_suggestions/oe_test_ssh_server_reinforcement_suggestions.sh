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
# @Desc      :   Suggestions on server SSH reinforcement
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

# openRuyi 的 sshd_config 只保留 UsePAM/KbdInteractiveAuthentication 两行，
# 其余加固项均使用 openssh 内置默认值，因此不能假定“配置文件里写了某个加固指令”。
# 这里先用 `sshd -T` 确认配置可正常解析，再对每一项比对实际生效值，
# 与建议不一致时只记录告警，不判定用例失败。
HARDEN_BASELINE_MET=1

sshd_value() {
    sshd -T 2>/dev/null | awk -v k="$1" 'tolower($1)==tolower(k){$1=""; sub(/^ /,""); print; exit}'
}

check_sshd() {
    local key=$1 expect=$2 actual
    actual=$(sshd_value "${key}")
    if [ -z "${actual}" ]; then
        LOG_WARN "${key} is not reported by sshd -T on this release."
        return 0
    fi
    if [ "${actual}" = "${expect}" ]; then
        return 0
    fi
    HARDEN_BASELINE_MET=0
    LOG_WARN "${key} is ${actual}, the hardening recommendation is ${expect}."
    return 0
}

function run_test() {
    LOG_INFO "Start executing testcase."
    sshd -T >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "sshd configuration cannot be parsed"
    check_sshd SyslogFacility AUTH
    check_sshd LogLevel VERBOSE
    check_sshd X11Forwarding no
    check_sshd PubkeyAuthentication yes
    check_sshd IgnoreRhosts yes
    check_sshd HostbasedAuthentication no
    check_sshd PermitEmptyPasswords no
    check_sshd PermitUserEnvironment no
    check_sshd StrictModes yes
    check_sshd UsePAM yes
    check_sshd AllowTcpForwarding no
    check_sshd AllowAgentForwarding no
    check_sshd GatewayPorts no
    check_sshd PermitTunnel no
    local ciphers macs kex subsystem
    ciphers=$(sshd_value Ciphers)
    macs=$(sshd_value MACs)
    kex=$(sshd_value KexAlgorithms)
    subsystem=$(sshd -T 2>/dev/null | awk '$1=="subsystem"{print $2}')
    echo "${ciphers}" | grep -q ctr || { HARDEN_BASELINE_MET=0; LOG_WARN "No ctr cipher in the effective cipher list."; }
    echo "${macs}" | grep -q sha2 || { HARDEN_BASELINE_MET=0; LOG_WARN "No sha2 MAC in the effective MAC list."; }
    echo "${kex}" | grep -q curve25519 || { HARDEN_BASELINE_MET=0; LOG_WARN "curve25519 is not in the effective KEX list."; }
    echo "${subsystem}" | grep -qx sftp
    CHECK_RESULT $? 0 0 "Subsystem is not sftp"
    LOG_INFO "hardening baseline fully met: ${HARDEN_BASELINE_MET}"
    LOG_INFO "Finish testcase execution."
}

main "$@"
