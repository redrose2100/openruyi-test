#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   dingjiao
# @Contact   :   dingjiao666@163.com
# @Date      :   2023/01/20
# @License   :   Mulan PSL v2
# @Desc      :   Check rpm package suffix name of rpm package
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # rpm 包名的架构后缀应与 uname -m 一致（x86_64/aarch64/riscv64/loongarch64 等）。
    # 原实现取 uname -a 的第 3 列（内核 release，如 6.19.9-96.1.or）再取倒数第二段，
    # 得到的是内核版本号 "1"，并非包架构后缀，导致所有包都被判为后缀不匹配。
    suffix_name=$(uname -m)
    LOG_INFO "rpm arch suffix is: ${suffix_name}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # dnf list 同时列出二进制包与源码包，行格式为 "name.arch  version  repo"。
    # 只取第一列包名；.noarch 与 .src 与 CPU 架构无关，不参与后缀检查。
    pkg_names=$(dnf list 2>/dev/null |
        grep -vE "^(Installed|Available) [Pp]ackages|Last metadata expiration" |
        awk 'NF >= 2 {print $1}' |
        grep -vE "^$")
    wrong_suffix=$(echo "${pkg_names}" | grep -vE "\.(noarch|src)$" | grep -v "\.${suffix_name}$")
    if [ -n "${wrong_suffix}" ]; then
        LOG_ERROR "Packages whose suffix is not .${suffix_name}:"
        echo "${wrong_suffix}" | head -20
    fi
    test -z "${wrong_suffix}"
    CHECK_RESULT $? 0 0 "Check rpm package name: failed!"
    LOG_INFO "End to run test."
}

main "$@"
