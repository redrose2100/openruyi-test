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
        while read -r svc; do
            [ -n "${svc}" ] && {
                echo "${svc}" >> all_services
                echo "${svc} ${package}" >> service_pkg_map
            }
        done < <(rpm -ql "${package}" | grep "/lib/systemd/system/" | grep -v "@" | grep -E "\.service$|\.target$|\.socket$" | awk -F '/' '{print $NF}')
    done < update_list
}

function check_new_service() {
    service=$1
    systemctl cat "${service}" >systemd_file
    if grep "Type=oneshot" systemd_file; then
        systemctl start "${service}" 
        test_oneshot "${service}" 'inactive (dead)'
    else
        test_execution "${service}"
        test_reload "${service}"
    fi
}

function clean_up_env() {
    while read -r service; do
        systemctl stop "${service}"      
    done <all_services 

    while read -r pkg; do
        yum remove -y "${pkg}" >>remove_log 2>&1
    done <update_list   
}

function extract_failure_reason() {
    local svc=$1
    systemctl --no-pager status "${svc}" 2>&1 \
        | grep -E "Active:|Failed|failed|error|Error|Could not|No such|not found" \
        | head -3 | sed 's/^[[:space:]]*//' | tr '\n' '; ' | sed 's/; $//'
}

function check_and_record() {
    local before=$exec_result
    CHECK_RESULT "$1" "$2" "$3" "$4"
    if [ "$exec_result" -gt "$before" ]; then
        local reason="$4"
        [ -z "$reason" ] && reason="$(extract_failure_reason "${_CUR_SVC}")"
        echo "${_CUR_PKG} | ${_CUR_SVC} | $5 | ${reason}" >> service_failed_table.txt
    fi
}

function print_failure_table() {
    if [ -s service_failed_table.txt ]; then
        LOG_INFO "==================== Failed Services Summary ===================="
        LOG_INFO "package | service | operation | failure reason"
        LOG_INFO "----------------------------------------------------------------"
        while read -r line; do
            LOG_INFO "${line}"
        done < service_failed_table.txt
        LOG_INFO "================================================================="
    else
        LOG_INFO "All services passed, no failure record."
    fi
}

function test_execution() {
    service=$1
    log_time="$(date '+%Y-%m-%d %T')"
    test_restart "${service}"
    test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    check_and_record $? 0 1 "There is an error message for the log of ${service}" "journalctl-error-check"
}

function test_restart() {
    service=$1
    systemctl restart "${service}"
    check_and_record $? 0 0 "${service} restart failed" "restart"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: active"
    check_and_record $? 0 0 "${service} restart failed" "restart-check-active"
    systemctl stop "${service}"
    check_and_record $? 0 0 "${service} stop failed" "stop"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: inactive"
    check_and_record $? 0 0 "${service} stop failed" "stop-check-inactive"
    systemctl start "${service}"
    check_and_record $? 0 0 "${service} start failed" "start"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: active"
    check_and_record $? 0 0 "${service} start failed" "start-check-active"
}

function test_oneshot() {
    service=$1
    status=$2
    log_time="$(date '+%Y-%m-%d %T')"
    systemctl status "${service}" | grep "Active" | grep -v "${status}"
    check_and_record $? 0 1 "There is an error for the status of ${service}" "oneshot-status-check"
    test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    check_and_record $? 0 1 "There is an error message for the log of ${service}" "journalctl-error-check"
}

function test_enabled() {
    service=$1
    state="$(systemctl is-enabled "${service}")"
    if [ "${state}" == "enabled" ]; then
        symlink_file=$(systemctl disable "${service}" 2>&1 | grep "Removed" | awk '{print $2}' | awk '{print substr($0,1,length($0)-1)}' | tr -d '"')
        find ${symlink_file}
        check_and_record $? 0 1 "${service} disable failed" "disable"
        systemctl enable "${service}"
        find ${symlink_file}
        check_and_record $? 0 0 "${service} enable failed" "enable"
    elif [ "${state}" == "disabled" ]; then
        symlink_file=$(systemctl enable "${service}" 2>&1 | grep "Created symlink" | awk '{print $3}' | tr -d '"')
        find ${symlink_file}
        check_and_record $? 0 0 "${service} enable failed" "enable"
        systemctl disable "${service}"
        find ${symlink_file}
        check_and_record $? 0 1 "${service} disable failed" "disable"
    elif [ "${state}" == "masked" ]; then
        LOG_INFO "Unit is masked, ignoring."
    elif [ "${state}" == "static" ]; then
        LOG_INFO "The unit files have no installation config,This means they are not meant to be enabled using systemctl."
    else
        LOG_INFO "Unit is indirect, ignoring."
    fi
}

function test_reload() {
    service=$1
    systemctl start "${service}"
    if systemctl show "${service}" -p CanReload | grep CanReload=yes; then
        systemctl reload "${service}"
        check_and_record $? 0 0 "reload unit ${service} failed" "reload"
    else
        systemctl reload "${service}" 2>&1 | grep "Job type reload is not applicable"
        check_and_record $? 0 0 "Job type reload is not applicable for unit ${service}" "reload-check"
    fi
    if ! systemctl status "${service}" | grep "Active: active"; then
        if systemctl status "${service}" | grep "inactive (dead)"; then
            systemctl status "${service}" | grep "Condition check" | grep "skip"
            check_and_record $? 0 0 "${service} reload causes the service status to change" "reload-status-check"
        else
            return 1
        fi
    fi
}
