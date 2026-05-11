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
# @Date      :   2026/5/13
# @License   :   Mulan PSL v2
# @Desc      :   Test ntpq -p/-n peers and -c interactive commands
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 全局状态变量
original_ntpd_status=""
ntp_installed_by_test=false
ntp_conf_backup=""
ntpd_started_by_test=false

# 等待 NTP 服务可达
function wait_for_ntp() {
    local max_attempts=10
    local attempt=0
    while [[ $attempt -lt $max_attempts ]]; do
        if ntpq -c rv &>/dev/null; then
            LOG_INFO "NTP reachable after $((attempt+1)) attempts"
            return 0
        fi
        sleep 2
        ((attempt++))
    done
    LOG_WARN "NTP not reachable after $max_attempts attempts"
    return 1
}

function pre_test() {
    LOG_INFO "Start environmental preparation."

    # 1. 安装 ntp（如果未安装）
    if ! which ntpq &>/dev/null; then
        DNF_INSTALL ntp
        if [[ $? -eq 0 ]]; then
            ntp_installed_by_test=true
            LOG_INFO "ntp installed successfully."
        else
            LOG_ERROR "Failed to install ntp, skip tests."
            exit 1
        fi
    else
        LOG_INFO "ntpq already present, skip installation."
    fi

    # 2. 配置 /etc/ntp.conf（添加本地时钟源）
    local ntp_conf="/etc/ntp.conf"
    local local_server="server 127.127.1.0"
    if [[ -f "$ntp_conf" ]]; then
        ntp_conf_backup="${ntp_conf}.backup_$(date +%Y%m%d%H%M%S)"
        cp "$ntp_conf" "$ntp_conf_backup"
        LOG_INFO "Backup original ntp.conf to $ntp_conf_backup"
        if ! grep -q "^$local_server" "$ntp_conf"; then
            echo "$local_server" >> "$ntp_conf"
            LOG_INFO "Added '$local_server' to $ntp_conf"
        else
            LOG_INFO "Local clock server already exists in $ntp_conf"
        fi
    else
        LOG_WARN "$ntp_conf not found, creating with local server"
        echo "$local_server" > "$ntp_conf"
        ntp_conf_backup=""   # 无原始配置，无需恢复
    fi

    # 3. 管理 ntpd 服务（记录原始状态，并根据需要启动/重启以应用新配置）
    if command -v systemctl &>/dev/null; then
        if systemctl is-active --quiet ntpd; then
            original_ntpd_status="active"
            LOG_INFO "ntpd was running, restarting to apply config."
            systemctl restart ntpd
        else
            original_ntpd_status="inactive"
            LOG_INFO "ntpd is not running, will try to start it."
            systemctl start ntpd
        fi
    elif command -v service &>/dev/null; then
        if service ntpd status &>/dev/null; then
            original_ntpd_status="active"
            service ntpd restart
        else
            original_ntpd_status="inactive"
            service ntpd start
        fi
    else
        LOG_WARN "No service manager found, attempting to run ntpd directly"
        if pgrep ntpd &>/dev/null; then
            original_ntpd_status="active"
            pkill ntpd; sleep 1; ntpd -g
        else
            original_ntpd_status="inactive"
            ntpd -g
        fi
    fi

    # 等待服务启动并验证可达性
    if wait_for_ntp; then
        ntpd_started_by_test=true
        LOG_INFO "ntpd is ready."
    else
        LOG_WARN "ntpd may not be fully ready, some tests may be skipped."
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 基本命令测试
    ntpq -c version | grep -E "[0-9]+\.[0-9]"
    CHECK_RESULT $? 0 0 "ntpq -c version failed"

    ntpq -c help 2>&1 | grep -q "ntpq commands"
    CHECK_RESULT $? 0 0 "ntpq -c help failed"

    # 如果 NTP 不可达，跳过依赖网络/服务的测试
    if ! ntpq -c rv &>/dev/null; then
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
    LOG_INFO "Start environment cleanup."

    # 1. 停止 ntpd（仅当测试期间我们启动/重启过，且原始状态为 inactive）
    if [[ "$ntpd_started_by_test" == "true" && "$original_ntpd_status" == "inactive" ]]; then
        if command -v systemctl &>/dev/null; then
            systemctl stop ntpd
            LOG_INFO "Stopped ntpd (was inactive before test)."
        elif command -v service &>/dev/null; then
            service ntpd stop
        else
            pkill ntpd
        fi
    fi

    # 2. 恢复原始 ntp.conf 配置并删除备份文件
    if [[ -n "$ntp_conf_backup" && -f "$ntp_conf_backup" ]]; then
        cp "$ntp_conf_backup" "/etc/ntp.conf"
        LOG_INFO "Restored original /etc/ntp.conf from backup."
        rm -f "$ntp_conf_backup"
        LOG_INFO "Removed backup file $ntp_conf_backup"
    fi

    # 3. 如果测试期间安装了 ntp，则卸载
    if [[ "$ntp_installed_by_test" == true ]]; then
        LOG_INFO "Removing ntp package..."
        #shellcheck disable=SC2119
        DNF_REMOVE        
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
