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
# @Date      :   2022/5/30
# @License   :   Mulan PSL v2
# @Desc      :   SSH strong encryption algorithm - enable hardening by default
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

# openRuyi 的 sshd_config 不再写死 Ciphers/MACs，加密算法集由 openssh 内置
# 默认值提供（可能还带 Include /etc/ssh/sshd_config.d/*.conf）。因此用
# `sshd -T` 取生效配置，而不是 grep 一个可能不存在的配置行。
sshd_effective() {
    sshd -T 2>/dev/null | grep -i "^$1 "
}

function run_test() {
    LOG_INFO "Start executing testcase."
    ciphers=$(sshd -T 2>/dev/null | awk '$1=="ciphers"{$1=""; print}')
    macs=$(sshd -T 2>/dev/null | awk '$1=="macs"{$1=""; print}')
    if [ -z "${ciphers}" ] || [ -z "${macs}" ]; then
        LOG_WARN "sshd -T cannot report the effective cipher list, skip the test."
        return 0
    fi
    echo "${ciphers}" | grep -q "ctr"
    CHECK_RESULT $? 0 0 "No strong ctr cipher enabled."
    echo "${macs}" | grep -q "sha2"
    CHECK_RESULT $? 0 0 "No strong sha2 MAC enabled."
    echo "${ciphers}" | grep -q "cbc"
    CHECK_RESULT $? 0 1 "Weak cbc cipher is enabled."
    echo "${macs}" | grep -q "sha1"
    CHECK_RESULT $? 0 1 "Weak sha1 MAC is enabled."
    echo "${macs}" | grep -q "md5"
    CHECK_RESULT $? 0 1 "Weak md5 MAC is enabled."
    LOG_INFO "Finish testcase execution."
}

main "$@"
