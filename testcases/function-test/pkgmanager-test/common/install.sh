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
# @Desc      :   For remote installation
# ############################################
# shellcheck disable=SC1091,SC2181,SC2154

source ./noproblem_list
source /etc/openEuler-latest
export LANG=en_US.UTF-8


install_test_pkg() {
    cd /home/pkg_manager_folder || exit
    # dnf config-manager --disable "${openeulerversion}_source_${test_update_repo}"
    # test -s EPOL_update_list && dnf config-manager --disable "${openeulerversion}_EPOL_source_${test_EPOL_update_repo}"
    test -s update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            # escape pkg default error
            echo "${pkg} Escape error !!!" >"${pkg}"_install_log
            echo "${pkg}" >>install_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum install -y "${pkg}" >"${pkg}"_install_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_install_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>install_fail_list
        fi
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            # escape pkg default error
            echo "${pkg} Escape error !!!" >"${pkg}"_EPOL_install_log
            echo "${pkg}" >>EPOL_install_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum install -y "${pkg}" >"${pkg}"_EPOL_install_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_EPOL_install_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>EPOL_install_fail_list
        fi
    done <EPOL_update_list

    test -s update_list && rpm -ql "$(cat update_list)" | grep "\.ko$" | grep -vE "TUTORIAL|gtkrc|mc.hint|README|tutor|kernel" >ko.list
    test -s EPOL_update_list && rpm -ql "$(cat EPOL_update_list)" | grep "\.ko$" | grep -vE "TUTORIAL|gtkrc|mc.hint|README|tutor" >>ko.list
    test -s ko.list && while read -r ko_file; do
        mod=$(echo "${ko_file}" | awk -F/ '{print $NF}' | awk -F '.ko' '{print $1}')
        modprobe "${mod}"
        if lsmod | grep -w "${mod}"; then
            modprobe -r "${mod}"
            lsmod | grep -w "${mod}"
        else
            insmod "${ko_file}" || echo "${mod}" >>ko_fail_list
            rmmod "${ko_file}"
        fi
    done <ko.list
}


install_test_pkg
