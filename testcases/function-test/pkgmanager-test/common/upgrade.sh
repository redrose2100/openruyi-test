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
# @Desc      :   For remote upgrade
# ############################################
# shellcheck disable=SC1091,SC2154,SC2181,SC2154

source ./noproblem_list
# /etc/openEuler-latest 在衍生发行版上不存在，交由 os_release_lib.sh 兜底。
source "${OET_PATH}"/libs/locallibs/os_release_lib.sh
OS_RELEASE_EXPORT_VERSION
export LANG=en_US.UTF-8


upgrade_test_pkg() {
    target_ver=$(find /etc/yum.repos.d | sort | tail -n 1 | awk -F '/' '{print $4}' | awk -F '.repo' '{print $1}')
    find /etc/yum.repos.d | sort | tail -n 1 | awk -F '/' '{print $4}' | awk -F '.repo' '{print $1}'
    service_ip=121.36.84.172
    test_update_repo=$(curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/"${openeulerversion}"-update.json | grep dir | grep "[0-9]" | grep -v test | grep -v round | awk -F \" '{print $4}' | awk -F "/" '{print $1}' | sort | uniq | tail -n 1)
    test_EPOL_update_repo=$(curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${openeulerversion}"-update.json | grep dir | grep "[0-9]" | grep -v test | awk -F \" '{print $4}' | awk -F "/" '{print $1}' | sort | uniq | tail -n 1 | awk -F "|" '{print $1}')

    if [ "${openeulerversion}"x == "${target_ver}"x ]; then
        dnf config-manager --disable "${target_ver}_${test_update_repo}"
        test -s EPOL_update_list && dnf config-manager --disable "${target_ver}_EPOL_${test_EPOL_update_repo}"
    else
        mv /etc/yum.repos.d/"${target_ver}".repo /etc/yum.repos.d/"${target_ver}".repo.bak
    fi
    yum clean all
    # Install last version
    test -s update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -ne 0 ]; then
            yum install -y "$pkg" >>install_log 2>&1
        fi
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -ne 0 ]; then
            yum install -y "$pkg" >>EPOL_install_log 2>&1
        fi
    done <EPOL_update_list
    # Upgrade test version
    if [ "${openeulerversion}"x == "${target_ver}"x ]; then
        dnf config-manager --enable "${target_ver}_${test_update_repo}"
        test -s EPOL_update_list && dnf config-manager --enable "${target_ver}_EPOL_${test_EPOL_update_repo}"
    else
        mv /etc/yum.repos.d/"${target_ver}".repo.bak /etc/yum.repos.d/"${target_ver}".repo
    fi
    test -s update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            echo "${pkg} Escape error !!!" >"${pkg}"_upgrade_log
            echo "${pkg}" >>upgrade_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum upgrade -y "${pkg}" >"${pkg}"_upgrade_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_upgrade_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>upgrade_fail_list
        fi
        
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -eq 0 ]; then
            echo "${pkg} Escape error !!!" >"${pkg}"_EPOL_upgrade_log
            echo "${pkg}" >>EPOL_upgrade_fail_list
        else
            # noproblem_info=$(eval echo '$'"${pkg}"_noproblem)
            yum upgrade -y "${pkg}" >"${pkg}"_EPOL_upgrade_log 2>&1
            grep -inE "fail|error|warn|fatal|problem|Invalid|Skip|no such|Cound not|conflicts|not found" "${pkg}"_EPOL_upgrade_log |grep -v "${be_common}"|grep -v "${pkg_name}"|grep -v "${other}" && echo "${pkg}" >>EPOL_upgrade_fail_list
        fi
        
    done <EPOL_update_list
    test -s update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -ne 0 ]; then
            yum upgrade -y "${pkg}" >"${pkg}"_EPOL_upgrade_log2 2>&1
        fi
    done <update_list
    test -s EPOL_update_list && while read -r pkg; do
        grep -Pq "^${pkg}$" escape.pkg
        if [ $? -ne 0 ]; then
            yum upgrade -y "${pkg}" >"${pkg}"_EPOL_upgrade_log2 2>&1
        fi
    done <EPOL_update_list
}


upgrade_test_pkg
