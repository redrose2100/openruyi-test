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
# @Date      :   2020/05/29
# @License   :   Mulan PSL v2
# @Desc      :   Kernel parameter hardening
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

# 直接读 /proc/sys 取内核参数的实际生效值。
# 原来用 `sysctl -p | grep`，但 sysctl 属于 procps-ng，openRuyi 等发行版
# 上 procps-ng 与 coreutils 的 /usr/bin/uptime 冲突装不上，sysctl 不存在，
# 于是所有断言都退化成 “command not found”。/proc/sys 是内核接口，不依赖
# 任何软件包，且读到的是真实生效值（比解析 sysctl 输出更直接）。
function read_sysctl() {
    local key=$1 path
    path="/proc/sys/${key//.//}"
    [ -r "${path}" ] || return 1
    local value
    value=$(cat "${path}" 2>/dev/null)
    # 个别参数是多行/多值，取第一个值比较
    printf '%s' "${value%%$'\n'*}"
}

function check_sysctl() {
    local key=$1 expect=$2 actual
    actual=$(read_sysctl "${key}")
    CHECK_RESULT "${actual}" "${expect}" 0 "kernel parameter ${key} is not ${expect}"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    check_sysctl net.ipv4.icmp_echo_ignore_broadcasts 1
    check_sysctl net.ipv4.conf.all.rp_filter 1
    check_sysctl net.ipv4.conf.default.rp_filter 1
    check_sysctl net.ipv4.ip_forward 0
    check_sysctl net.ipv4.conf.all.accept_source_route 0
    check_sysctl net.ipv4.conf.default.accept_source_route 0
    check_sysctl net.ipv4.conf.all.accept_redirects 0
    check_sysctl net.ipv4.conf.default.accept_redirects 0
    check_sysctl net.ipv6.conf.all.accept_redirects 0
    check_sysctl net.ipv6.conf.default.accept_redirects 0
    check_sysctl net.ipv4.conf.all.send_redirects 0
    check_sysctl net.ipv4.conf.default.send_redirects 0
    check_sysctl net.ipv4.icmp_ignore_bogus_error_responses 1
    check_sysctl net.ipv4.tcp_syncookies 1
    check_sysctl kernel.dmesg_restrict 1
    check_sysctl kernel.sysrq 0
    check_sysctl net.ipv4.conf.all.secure_redirects 0
    check_sysctl net.ipv4.conf.default.secure_redirects 0
    LOG_INFO "Finish testcase execution."
}
main "$@"
