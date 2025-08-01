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
# shellcheck disable=SC1091,SC2181,SC2154


source ./noproblem_list
export LANG=en_US.UTF-8


function downgrade_pkg() {
    while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            echo "${pkg} Escape error !!!" >"${pkg}"_downgrade_log
            echo "${pkg}" >>downgrade_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum downgrade -y "${pkg}" >"${pkg}"_downgrade_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_downgrade_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>downgrade_fail_list
        fi
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            echo "${pkg} Escape error !!!" >EPOL_"${pkg}"_downgrade_log
            echo "${pkg}" >>EPOL_downgrade_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum downgrade -y "${pkg}" >EPOL_"${pkg}"_downgrade_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_EPOL_downgrade_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>EPOL_downgrade_fail_list
        fi
    done <EPOL_update_list
}


downgrade_pkg
