#! /usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhanglu
# @Contact   :   m18409319968@163.com
# @Date      :   2023-07-12
# @License   :   Mulan PSL v2
# @Desc      :   For remote downgrade
# ############################################
# shellcheck disable=SC1091

source ./noproblem_list
export LANG=en_US.UTF-8

function downgrade_pkg() {
    noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
    while read -r pkg; do
        yum downgrade -y "${pkg}" >"${pkg}"_downgrade_log 2>&1
        grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_downgrade_log | grep -v "perl-Error\|texlive-parskip\|Curl error\|Unable to find a match:\|${noproblem_info}" && echo "${pkg}" >>downgrade_fail_list
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        yum downgrade -y "${pkg}" >EPOL_"${pkg}"_downgrade_log 2>&1
        grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_EPOL_downgrade_log | grep -v "perl-Error\|texlive-parskip\|Curl error\|Unable to find a match:\|${noproblem_info}" && echo "${pkg}" >>EPOL_downgrade_fail_list
    done <EPOL_update_list
}

downgrade_pkg
