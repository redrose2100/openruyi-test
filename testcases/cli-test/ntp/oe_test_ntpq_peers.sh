#!/usr/bin/bash
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   郑威
# @Contact   :   zhengwei@uniontech.com
# @Date      :   2026/5/11
# @License   :   Mulan PSL v2
# @Desc      :   Test ntpq -p/-n peers and -c interactive commands
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 保存 ntpd 服务的原始状态（active/inactive），用于恢复
original_ntpd_status=""

function pre_test() {
    LOG_INFO "Start environmental preparation."
    which ntpq &>/dev/null || { LOG_WARN "ntpq not found, skip all"; exit 0; }
    if command -v systemctl &>/dev/null; then
        if systemctl is-active --quiet ntpd; then
            original_ntpd_status="active"
        else
            original_ntpd_status="inactive"
            LOG_WARN "ntpd is not running, will try to start it."
            systemctl start ntpd && sleep 2 && LOG_INFO "ntpd started."
        fi
    fi
    LOG_INFO "End of environmental preparation!"
}

function check_ntp_reachable() {
    ntpq -c rv &>/dev/null
}

function run_test() {
    LOG_INFO "Start to run test."
    ntpq -c version | grep -E "[0-9]+\.[0-9]"
    CHECK_RESULT $? 0 0 "ntpq -c version failed"
    ntpq -c help 2>&1 | grep -q "ntpq commands"
    CHECK_RESULT $? 0 0 "ntpq -c help failed"

    if ! check_ntp_reachable; then
        LOG_WARN "NTP unreachable, skip advanced tests."
        return 0
    fi

    # 3. ntpq -p
    local out
    out=$(ntpq -p 2>&1)
    CHECK_RESULT $? 0 0 "ntpq -p execution failed"
    if echo "$out" | grep -qiE "remote\s+refid\s+st\s+t\s+when\s+poll\s+reach\s+delay\s+offset\s+jitter"; then
        LOG_INFO "ntpq -p: header OK"
    elif echo "$out" | grep -qi "no associations found"; then
        LOG_WARN "ntpq -p: no associations"
    else
        LOG_ERROR "ntpq -p output: $out"
        CHECK_RESULT 1 0 0 "ntpq -p invalid output"
    fi

    # 4. ntpq -n -p
    out=$(ntpq -n -p 2>&1)
    CHECK_RESULT $? 0 0 "ntpq -n -p execution failed"
    echo "$out" | tail -n +2 | grep -qE "[a-zA-Z]" && LOG_WARN "ntpq -n still has letters"

    # 5. ntpq -c peers
    out=$(ntpq -c "peers" 2>&1)
    CHECK_RESULT $? 0 0 "ntpq -c peers execution failed"
    if echo "$out" | grep -qiE "remote\s+refid\s+st\s+t\s+when\s+poll\s+reach\s+delay\s+offset\s+jitter"; then
        LOG_INFO "ntpq -c peers: header OK"
    elif echo "$out" | grep -qi "no associations found"; then
        LOG_WARN "ntpq -c peers: no associations"
    else
        LOG_ERROR "ntpq -c peers output: $out"
        CHECK_RESULT 1 0 0 "ntpq -c peers invalid output"
    fi

    # 6. ntpq -c rv
    out=$(ntpq -c "rv" 2>&1)
    CHECK_RESULT $? 0 0 "ntpq -c rv execution failed"
    if echo "$out" | grep -qiE "associd|status|leap|clock|reftime|offset|frequency|version"; then
        LOG_INFO "ntpq -c rv contains system vars"
    else
        LOG_WARN "ntpq -c rv missing expected vars: $out"
    fi

    # 7. ntpq -c associations
    out=$(ntpq -c "associations" 2>&1)
    CHECK_RESULT $? 0 0 "ntpq -c associations execution failed"
    if echo "$out" | grep -qiE "ind\s+assid\s+status"; then
        LOG_INFO "ntpq -c associations: header OK"
    elif echo "$out" | grep -qi "no associations"; then
        LOG_WARN "ntpq -c associations: no associations"
    else
        LOG_ERROR "ntpq -c associations output: $out"
        CHECK_RESULT 1 0 0 "ntpq -c associations invalid output"
    fi

    # 8. readvar
    local first_assoc
    first_assoc=$(ntpq -c "rv" 2>&1 | grep -oE "associd=[0-9]+" | head -1 | cut -d= -f2)
    if [[ -n "$first_assoc" && "$first_assoc" =~ ^[0-9]+$ ]]; then
        ntpq -c "readvar $first_assoc" 2>&1 | grep -q "associd=$first_assoc"
        CHECK_RESULT $? 0 0 "readvar assoc $first_assoc failed"
        LOG_INFO "readvar test passed for assoc $first_assoc"
    else
        LOG_WARN "No associd, skip readvar"
    fi

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    if [[ "$original_ntpd_status" == "inactive" ]] && command -v systemctl &>/dev/null; then
        systemctl stop ntpd
        LOG_INFO "Stopped ntpd (was inactive before test)."
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
