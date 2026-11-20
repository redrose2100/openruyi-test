#!/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/11/03
# @License   :   Mulan PSL v2
# @Desc      :   common function library for service restart of the base images
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# Allowlist of journal lines that are known to be benign for this suite.
# One fixed string per line, matched with "grep -F". Every entry must carry a
# reason and the date it was verified; entries are added by review only.
JOURNAL_NOISE_FILE="${OET_PATH}/testcases/function-test/pkgs-test/common/journal_noise.txt"

# Print the first absolute filesystem path found on stdin.
# Only path safe characters are accepted, so the quoting styles used by
# "systemctl enable/disable" ("", '' or typographic quotes) are dropped by the
# pattern itself, which keeps this independent of the systemd version, the
# locale and the GBK/UTF-8 console encoding.
function _first_path() {
    grep -o "/[A-Za-z0-9_.@+/-]*" | head -n 1
}

# Return the symlink created by "systemctl enable" (empty when not printed).
function _get_enable_symlink() {
    systemctl enable "$1" 2>&1 | grep -F "Created symlink" | head -n 1 | _first_path
}

# Return the symlink removed by "systemctl disable" (empty when not printed).
function _get_disable_symlink() {
    systemctl disable "$1" 2>&1 | grep -F "Removed" | head -n 1 | _first_path
}

# Check the symlink reported by systemctl. $3 is "present" or "absent".
function _check_symlink() {
    local service=$1
    local symlink_file=$2
    local expect=$3
    local action=$4
    if [ -z "${symlink_file}" ]; then
        LOG_ERROR "${service} ${action} failed: could not parse the symlink path from the systemctl output"
        ((exec_result++))
        return 1
    fi
    LOG_INFO "${service} ${action} symlink: ${symlink_file}"
    case "${expect}" in
        present) [ -e "${symlink_file}" ] || [ -L "${symlink_file}" ] ;;
        absent) [ ! -e "${symlink_file}" ] && [ ! -L "${symlink_file}" ] ;;
        *)
            LOG_ERROR "invalid expectation: ${expect}"
            ((exec_result++))
            return 1
            ;;
    esac
    CHECK_RESULT $? 0 0 "${service} ${action} failed: ${symlink_file} should be ${expect}"
}

# A unit that terminates right after its main process exits. For such a unit
# "Active: active" is not an expected state, so it must not be asserted.
function _unit_is_short_lived() {
    local unit_type
    local remain_after_exit
    unit_type="$(systemctl show "$1" -p Type --value 2>/dev/null)"
    remain_after_exit="$(systemctl show "$1" -p RemainAfterExit --value 2>/dev/null)"
    [ "${unit_type}" == "oneshot" ] && [ "${remain_after_exit}" != "yes" ]
}

# Return 0 when the running state of the unit is acceptable, i.e. one of:
#   - "Active: active" (regular long running service)
#   - the unit finished its job and stayed inactive, and it is not failed
#     (short lived oneshot unit)
#   - the unit was intentionally skipped because its start condition was not met
#     (e.g. ConditionPathExists=/var/log/journal for systemd-journal-flush)
function _unit_state_ok() {
    local service=$1
    local condition_result
    if systemctl status "${service}" 2>&1 | grep -q "Active: active"; then
        return 0
    fi
    if systemctl is-failed --quiet "${service}"; then
        LOG_ERROR "${service} is in failed state"
        return 1
    fi
    condition_result="$(systemctl show "${service}" -p ConditionResult --value 2>/dev/null)"
    if [ "${condition_result}" == "no" ]; then
        LOG_INFO "${service} start condition was not met, the unit was intentionally skipped."
        return 0
    fi
    if _unit_is_short_lived "${service}"; then
        LOG_INFO "${service} terminated after its main process exited, which is expected."
        return 0
    fi
    systemctl status "${service}" 2>&1 | grep "Active:"
    return 1
}

# Assert that the unit itself reports a successful run. This is stronger and
# locale independent compared with the journal keyword grep, and it also
# catches ExecStart returning non zero, timeouts, signals and core dumps.
function _check_unit_result() {
    local service=$1
    local result
    result="$(systemctl show "${service}" -p Result --value 2>/dev/null)"
    if [ -z "${result}" ]; then
        LOG_INFO "no execution result recorded for ${service}, skip the Result check."
        return 0
    fi
    CHECK_RESULT "${result}" "success" 0 "${service} execution result is ${result}, expected success"
}

# Fail when the journal of the unit contains error level lines that are not
# listed in JOURNAL_NOISE_FILE. Returns 0 when clean, 1 when something is left.
function check_journal_errors() {
    local service=$1
    local since=$2
    local logs
    local matched
    local suppressed
    local kept
    local pattern_file

    logs="$(journalctl --since "${since}" -u "${service}" --no-pager 2>&1)"
    matched="$(printf '%s\n' "${logs}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING" | grep ".")"
    if [ -z "${matched}" ]; then
        return 0
    fi

    if [ ! -f "${JOURNAL_NOISE_FILE}" ]; then
        LOG_ERROR "journal noise allowlist ${JOURNAL_NOISE_FILE} is missing, nothing is filtered:"
        printf '%s\n' "${matched}"
        return 1
    fi

    pattern_file="$(mktemp)"
    grep -vE '^[[:space:]]*(#|$)' "${JOURNAL_NOISE_FILE}" > "${pattern_file}"
    if [ -s "${pattern_file}" ]; then
        suppressed="$(printf '%s\n' "${matched}" | grep -F -f "${pattern_file}" | grep ".")"
        kept="$(printf '%s\n' "${matched}" | grep -v -F -f "${pattern_file}" | grep ".")"
    else
        # An allowlist without any entry must not suppress anything, otherwise
        # a wrongly emptied file would silently hide every journal error.
        suppressed=""
        kept="${matched}"
    fi
    rm -f "${pattern_file}"

    while IFS= read -r line; do
        [ -n "${line}" ] && LOG_INFO "known benign journal line of ${service}: ${line}"
    done <<< "${suppressed}"

    if [ -n "${kept}" ]; then
        while IFS= read -r line; do
            [ -n "${line}" ] && LOG_ERROR "unexpected journal line of ${service}: ${line}"
        done <<< "${kept}"
        return 1
    fi
    return 0
}

function test_execution() {
    service=$1
    log_time="$(date '+%Y-%m-%d %T')"
    test_restart "${service}"
    _check_unit_result "${service}"
    test_enabled "${service}"
    check_journal_errors "${service}" "${log_time}"
    CHECK_RESULT $? 0 0 "There is an error message for the log of ${service}"
}

function test_restart() {
    service=$1
    systemctl restart "${service}"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    SLEEP_WAIT 5
    _unit_state_ok "${service}"
    CHECK_RESULT $? 0 0 "${service} restart failed, unexpected state after restart"
    systemctl stop "${service}"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    systemctl start "${service}"
    CHECK_RESULT $? 0 0 "${service} start failed"
    SLEEP_WAIT 5
    _unit_state_ok "${service}"
    CHECK_RESULT $? 0 0 "${service} start failed, unexpected state after start"
}

function test_oneshot() {
    service=$1
    status=$2
    log_time="$(date '+%Y-%m-%d %T')"
    systemctl status "${service}" | grep "Active" | grep -v "${status}"
    CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
    _check_unit_result "${service}"
    test_enabled "${service}"
    check_journal_errors "${service}" "${log_time}"
    CHECK_RESULT $? 0 0 "There is an error message for the log of ${service}"
}

function test_enabled() {
    service=$1
    state="$(systemctl is-enabled "${service}")"
    if [ "${state}" == "enabled" ]; then
        symlink_file="$(_get_disable_symlink "${service}")"
        _check_symlink "${service}" "${symlink_file}" absent disable
        symlink_file="$(_get_enable_symlink "${service}")"
        _check_symlink "${service}" "${symlink_file}" present enable
    elif [ "${state}" == "disabled" ]; then
        symlink_file="$(_get_enable_symlink "${service}")"
        _check_symlink "${service}" "${symlink_file}" present enable
        symlink_file="$(_get_disable_symlink "${service}")"
        _check_symlink "${service}" "${symlink_file}" absent disable
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
        CHECK_RESULT $? 0 0 "reload unit ${service} failed"
    else
        systemctl reload "${service}" 2>&1 | grep "Job type reload is not applicable"
        CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
    fi
    # A short lived unit is expected to be inactive after the reload, asserting
    # "Active: active" here would report a false failure.
    if _unit_is_short_lived "${service}"; then
        LOG_INFO "${service} terminates after its main process exits, skip the reload status check."
        return 0
    fi
    # A unit whose start condition is not met is legitimately inactive, the
    # skip is reported by systemd itself instead of a localized status line.
    if [ "$(systemctl show "${service}" -p ConditionResult --value 2>/dev/null)" == "no" ]; then
        LOG_INFO "${service} start condition was not met, the unit was intentionally skipped."
        return 0
    fi
    systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
}
