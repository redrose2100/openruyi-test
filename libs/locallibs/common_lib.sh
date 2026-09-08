#!/usr/bin/bash
# Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author  : lemon-higgins
# @email   : lemon.higgins@aliyun.com
# @Date    : 2021-04-20 15:11:47
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc    :
#####################################
# shellcheck disable=SC1090

if python3 --version; then
    source "$OET_PATH/libs/locallibs/common_lib_python.sh"
else
    source "$OET_PATH/libs/locallibs/common_lib_shell.sh"
fi

function CHECK_RESULT() {
    actual_result=$1
    expect_result=${2-0}
    mode=${3-0}
    error_log=$4
    exit_mode=${5-0}

    if [ -z "$*" ]; then
        LOG_ERROR "Missing parameter error code."
        ((exec_result++))
        return 1
    fi

    if [ "$mode" -eq 0 ]; then
        test "$actual_result"x != "$expect_result"x && {
            test -n "$error_log" && LOG_ERROR "$error_log"
            ((exec_result++))
            LOG_ERROR "${BASH_SOURCE[1]} line ${BASH_LINENO[0]}"
            if [ "$exit_mode" -eq 1 ]; then
                exit 1
            fi
        }
    else
        test "$actual_result"x == "$expect_result"x && {
            test -n "$error_log" && LOG_ERROR "$error_log"
            ((exec_result++))
            LOG_ERROR "${BASH_SOURCE[1]} line ${BASH_LINENO[0]}"
            if [ "$exit_mode" -eq 1 ]; then
                exit 1
            fi
        }
    fi

    return 0
}

function CASE_RESULT() {
    case_re=$1

    test -z "$exec_result" && {
        test "$case_re" -eq 0 && {
            LOG_INFO "succeed to execute the case."
            exec_result=""
            exit 0
        }
        LOG_ERROR "failed to execute the case."
        exit "$case_re"
    }

    test "$exec_result" -gt 0 && {
        LOG_ERROR "failed to execute the case."
        exit "$exec_result"
    }
    LOG_INFO "succeed to execute the case."
    exit "$exec_result"
}

# Check if a file or directory exists
# Usage: CHECK_FILE_EXISTS "/path/to/file"
# Returns: 0 if exists, 1 if not
function CHECK_FILE_EXISTS() {
    local target_path="$1"
    if [ -z "$target_path" ]; then
        LOG_ERROR "CHECK_FILE_EXISTS: No path specified."
        return 1
    fi
    if [ -e "$target_path" ]; then
        LOG_INFO "CHECK_FILE_EXISTS: '$target_path' exists."
        return 0
    else
        LOG_ERROR "CHECK_FILE_EXISTS: '$target_path' does not exist."
        return 1
    fi
}

# Check if a systemd service is in the expected state
# Usage: CHECK_SERVICE_STATUS "sshd" "active"
# $1: service name
# $2: expected state (active/inactive/failed/enabled/disabled), default is "active"
# Returns: 0 if matches, 1 if not
function CHECK_SERVICE_STATUS() {
    local service_name="$1"
    local expected_state="${2:-active}"
    if [ -z "$service_name" ]; then
        LOG_ERROR "CHECK_SERVICE_STATUS: No service name specified."
        return 1
    fi
    local current_state
    current_state=$(systemctl is-active "$service_name" 2>/dev/null)
    if [ "$current_state" = "$expected_state" ]; then
        LOG_INFO "CHECK_SERVICE_STATUS: '$service_name' is '$expected_state'."
        return 0
    else
        LOG_ERROR "CHECK_SERVICE_STATUS: '$service_name' is '$current_state', expected '$expected_state'."
        return 1
    fi
}

# Wait for a network port to be ready
# Usage: WAIT_FOR_PORT 8080 30
# $1: port number
# $2: timeout in seconds, default is 10
# Returns: 0 if port is ready within timeout, 1 if timeout
function WAIT_FOR_PORT() {
    local port="$1"
    local timeout="${2:-10}"
    if [ -z "$port" ]; then
        LOG_ERROR "WAIT_FOR_PORT: No port specified."
        return 1
    fi
    local elapsed=0
    while [ "$elapsed" -lt "$timeout" ]; do
        if ss -tlnp 2>/dev/null | grep -q ":${port} "; then
            LOG_INFO "WAIT_FOR_PORT: Port $port is ready after ${elapsed}s."
            return 0
        fi
        sleep 1
        elapsed=$((elapsed + 1))
    done
    LOG_ERROR "WAIT_FOR_PORT: Port $port not ready after ${timeout}s timeout."
    return 1
}

# Check if a command is available in PATH
# Usage: CHECK_CMD_AVAILABLE "docker"
# $1: command name
# Returns: 0 if available, 1 if not
function CHECK_CMD_AVAILABLE() {
    local cmd_name="$1"
    if [ -z "$cmd_name" ]; then
        LOG_ERROR "CHECK_CMD_AVAILABLE: No command name specified."
        return 1
    fi
    if command -v "$cmd_name" >/dev/null 2>&1; then
        LOG_INFO "CHECK_CMD_AVAILABLE: '$cmd_name' is available."
        return 0
    else
        LOG_ERROR "CHECK_CMD_AVAILABLE: '$cmd_name' is not available."
        return 1
    fi
}

function POST_TEST_DEFAULT() {
    LOG_INFO "$0 post_test"
}

function main() {
    # 只执行一次清理
    __TRAP_EXECUTED=0
    handle_signal() {
        if [ $__TRAP_EXECUTED -eq 0 ]; then
            __TRAP_EXECUTED=1
            if [ -n "$(type -t post_test)" ]; then
                post_test
            else
                POST_TEST_DEFAULT
            fi
        fi
        if [ $# -gt 0 ]; then
            if [ "$1" == "NOPKG" ]; then
                exit 255
            elif [ "$1" == "PKGCONFLICT" ]; then
                exit 247
            fi
        fi
    }
    trap handle_signal EXIT INT HUP TERM || exit 1
    trap "handle_signal NOPKG" SIGRTMIN || exit 255
    trap "handle_signal PKGCONFLICT" SIGRTMIN+1 || exit 247

    if ! rpm -qa | grep expect >/dev/null 2>&1; then
        dnf -y install expect
    fi

    if [ -n "$(type -t config_params)" ]; then
        config_params
    fi

    if [ -n "$(type -t pre_test)" ]; then
        pre_test
    fi

    if [ -n "$(type -t run_test)" ]; then
        run_test
        CASE_RESULT $?
    fi
}
