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

# 递归查找套件 json（支持 suite2cases 下任意层级分类目录），返回唯一路径。
# 找到 0 个返回 1；找到多个（重名）返回 2 并打印冲突候选，绝不静默任选。
function find_suite_json() {
    local test_suite=$1
    local suite2cases_dir="${OET_PATH}/suite2cases"
    mapfile -t matches < <(find "${suite2cases_dir}" -type f -name "${test_suite}.json" 2>/dev/null)
    case ${#matches[@]} in
        0)
            LOG_ERROR "In the suite2cases directory, Can't find the file of testsuite:${test_suite}."
            return 1
            ;;
        1)
            echo "${matches[0]}"
            return 0
            ;;
        *)
            LOG_ERROR "Duplicate suite name: ${test_suite}.json exists in multiple directories:"
            printf '  %s\n' "${matches[@]}"
            return 2
            ;;
    esac
}

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
