#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/08/01
# @License   :   Mulan PSL v2
# @Desc      :   Service update testing
# #############################################
# shellcheck disable=SC1091
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/libs/locallibs/configure_repo.sh"

function package_install() {
    LANG=en_US.UTF-8
    rm -rf /etc/yum.repos.d/*
    cfg_openEuler_repo
    cfg_openEuler_update_test_repo
    dnf list | grep "${version_info}_${test_update_repo}" | grep "arch\|x86_64" | awk '{print $1}' | awk -F. 'OFS="."{$NF="";print}' | awk '{print substr($0, 1, length($0)-1)}' >update_list
    while read -r pkg; do
        yum install -y "${pkg}" >>install_log 2>&1
    done <update_list
}

function search_all_services() {
    while read -r package; do
        rpm -ql "${package}" || echo "${package}" >> failed_install
        rpm -ql "${package}" | grep "/lib/systemd/system/" | grep -v "@" | grep -E "\.service$|\.target$|\.socket$" | awk -F '/' '{print $NF}' >> all_services
    done < update_list
}

function select_services() {
    while read -r service; do
        name=${service%.*}
        type=${service##*.}
        path=$(grep  -r -w \"oe_test_"$type"_"$name"\" "${OET_PATH}"/suite2cases/)
        echo "$path" >> file
        if [ -z "$path" ]; then
           echo "$service" >> new_service
        else
           echo "$service" >> adapted_service
        fi
    done < all_services
    sed -e '/^$/d' file > json_file
}

function check_service_restart() {
    service=$1
    systemctl cat "${service}" >systemd_file
    if grep "Type=oneshot" systemd_file; then
        systemctl start "${service}" 
        test_oneshot "${service}" 'inactive (dead)'
    else
        test_execution "${service}"
    fi
}

function check_service_reload() {
    service=$1
    if systemctl reload "${service}" 2>&1 | grep "Job type reload is not applicable"; then
        test_reload "${service}"
    else
        systemctl start "${service}"
        systemctl reload "${service}"
        CHECK_RESULT $? 0 0 "${service} reload failed"
        systemctl status "${service}" | grep "Active: active"
        CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
    fi
}

function test_adapted_service() {
    workdir="$(pwd)"
    while read -r line; do
        suite=$(echo "$line" | awk -F "/" '{print $NF}' | awk -F '.json' '{print $1}')
        case=$(echo "$line" | awk -F '"' '{print $(NF-1)}') 
        cd "${OET_PATH}" || exit 1
        bash mugen.sh -f "${suite}" -r "${case}" -x
        ls "${OET_PATH}"/results/"${suite}"/failed >>failed_case
        ls "${OET_PATH}"/results/"${suite}"/skipped >>failed_case
    done < json_file
    cd "${workdir}" || exit 1
}

function clean_up_env() {
    while read -r service; do
        systemctl stop "${service}"      
    done <all_services 

    while read -r pkg; do
        yum remove -y "${pkg}" >>remove_log 2>&1
    done <update_list   
}
