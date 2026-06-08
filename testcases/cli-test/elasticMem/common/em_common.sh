#!/usr/bin/bash
# #############################################
# elasticMem mugen suite common functions (安全版 v3)
# - 精确 PID 清理，不用 killall
# - DNF 安装先检测 + 安装后校验，卸载仅限本次安装的包
# - 备份配置后逐项验证恢复
# - NUMA 检测回退到 /sys（不依赖 numactl）
# - 用例产生的后台 PID 记录到 __EM_BG_PIDS，post_test 精确清理
# - 修复 Restart=on-failure 导致的直接 kill 被重启问题
# #############################################

CONFIG_PATH="/etc/elasticMem.ini"
CONFIG_BAK="/etc/elasticMem.ini.mugen_bak"
LOG_DIR="/var/log/elasticMem"
LOG_FILE="$LOG_DIR/elasticMem.log"
SERVICE_NAME="elasticMem"
BIN_PATH="/usr/bin/elasticMem"
CGROUP_BASE="/sys/fs/cgroup/cpuset"

__EM_BG_PIDS=()
__EM_DNF_INSTALLED=()

em_track_pid() {
    [ -n "$1" ] && [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -gt 1 ] && __EM_BG_PIDS+=("$1")
}

em_safe_kill() {
    local pid=$1
    [ -z "$pid" ] && return 0
    [[ "$pid" =~ ^[0-9]+$ ]] || return 0
    [ "$pid" -le 1 ] && return 0
    [ "$pid" -eq "$$" ] && return 0
    [ "$pid" -eq "$BASHPID" ] && return 0
    kill -0 "$pid" 2>/dev/null || return 0
    kill -TERM "$pid" 2>/dev/null
    return 0
}

# [v3新增] 安全杀掉 elasticMem 服务进程：先 systemctl stop 防止 Restart 重拉
em_kill_service_pid() {
    local pid=$1
    [ -z "$pid" ] && return 0
    # 先通过 systemctl 停止服务，避免 Restart=on-failure 立即重拉
    systemctl stop $SERVICE_NAME 2>/dev/null
    sleep 1
    # 如果进程仍在，补充 SIGTERM
    kill -0 "$pid" 2>/dev/null && kill -TERM "$pid" 2>/dev/null
    sleep 2
    # 如果还不死，SIGKILL
    kill -0 "$pid" 2>/dev/null && kill -KILL "$pid" 2>/dev/null
}

em_kill_bg() {
    local pid
    for pid in "${__EM_BG_PIDS[@]:-}"; do
        [ -z "$pid" ] && continue
        em_safe_kill "$pid"
    done
    sleep 3
    for pid in "${__EM_BG_PIDS[@]:-}"; do
        [ -z "$pid" ] && continue
        em_safe_kill "$pid" >/dev/null 2>&1
        kill -0 "$pid" 2>/dev/null && kill -KILL "$pid" 2>/dev/null
    done
    __EM_BG_PIDS=()
}

em_backup_config() {
    [ -f "$CONFIG_PATH" ] && cp -p "$CONFIG_PATH" "$CONFIG_BAK"
}

em_restore_config() {
    [ -f "$CONFIG_BAK" ] && cp -p "$CONFIG_BAK" "$CONFIG_PATH" 2>/dev/null && rm -f "$CONFIG_BAK"
}

em_stop_service() {
    systemctl stop $SERVICE_NAME 2>/dev/null
    sleep 2
    local p
    for p in $(pgrep -x elasticMem 2>/dev/null); do em_safe_kill "$p"; done
    sleep 1
    for p in $(pgrep -x elasticMem 2>/dev/null); do
        em_safe_kill "$p" >/dev/null 2>&1
        kill -0 "$p" 2>/dev/null && kill -KILL "$p" 2>/dev/null
    done
}

em_get_numa_count() {
    local count=""
    if command -v numactl >/dev/null 2>&1; then
        count=$(numactl --hardware 2>/dev/null | grep 'available:' | awk '{print $2}')
    fi
    if [ -z "$count" ] || ! [[ "$count" =~ ^[0-9]+$ ]]; then
        local online=$(cat /sys/devices/system/node/online 2>/dev/null)
        if [ -n "$online" ]; then
            count=$(echo "$online" | awk -F'[-,]' '{print NF}')
        else
            count=$(ls -d /sys/devices/system/node/node* 2>/dev/null | wc -l)
        fi
    fi
    echo "$count"
}

em_check_env() {
    local numa_count=$(em_get_numa_count)
    if [ -z "$numa_count" ] || ! [[ "$numa_count" =~ ^[0-9]+$ ]] || [ "$numa_count" -lt 2 ]; then
        LOG_WARN "NUMA nodes < 2 ($numa_count), skip test"
        return 1
    fi
    if ! ls /sys/devices/system/node/node0 >/dev/null 2>&1; then
        LOG_WARN "No NUMA node0 found, skip test"
        return 1
    fi
    return 0
}

em_get_service_pid() {
    local pid
    pid=$(systemctl show $SERVICE_NAME -p MainPID --value 2>/dev/null)
    if [ -n "$pid" ] && [ "$pid" -gt 0 ] 2>/dev/null; then
        echo "$pid"
    fi
}

em_write_paral_config() {
    local whitelist=${1:-[test]}
    local nr_cpus=${2:-1}
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = $LOG_FILE
whitelist = $whitelist
comm_whitelist = []
nr_cpus=$nr_cpus
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
}

em_write_light_config() {
    local whitelist=${1:-[]}
    local migration=${2:-true}
    local s_interval=${3:-100}
    local s_count=${4:-10}
    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = info
log_file = $LOG_FILE
whitelist = $whitelist
comm_whitelist = []
memory_migration = $migration
sample_interval = $s_interval
sample_count = $s_count
nr_cpus=1
EOF
}

em_start_service() {
    mkdir -p "$LOG_DIR" 2>/dev/null
    systemctl daemon-reload 2>/dev/null
    systemctl restart $SERVICE_NAME 2>/dev/null
    local retry=0
    while [ $retry -lt 10 ]; do
        sleep 2
        if systemctl is-active $SERVICE_NAME --quiet; then
            return 0
        fi
        retry=$((retry + 1))
    done
    systemctl is-active $SERVICE_NAME --quiet
}

em_assert_log_contains() {
    local pattern=$1
    local since=${2:-"2 min ago"}
    local retry=0
    while [ $retry -lt 10 ]; do
        journalctl -u $SERVICE_NAME --since "$since" --no-pager 2>/dev/null | grep -q "$pattern" && return 0
        [ -f "$LOG_FILE" ] && grep -q "$pattern" "$LOG_FILE" 2>/dev/null && return 0
        sleep 1
        retry=$((retry + 1))
    done
    return 1
}

# [v3新增] paral模式启动：paral处理完进程后正常退出(service变inactive)，
# 这是预期行为。此函数只确认服务曾启动且日志中有ParalTune激活记录。
em_start_service_for_paral() {
    mkdir -p "$LOG_DIR" 2>/dev/null
    > "$LOG_FILE"
    systemctl daemon-reload 2>/dev/null
    systemctl restart $SERVICE_NAME 2>/dev/null
    local retry=0
    while [ $retry -lt 15 ]; do
        sleep 1
        if systemctl is-active $SERVICE_NAME --quiet; then
            return 0
        fi
        grep -q "ParalTune activated\|Executing paral tune" "$LOG_FILE" 2>/dev/null && return 0
        retry=$((retry + 1))
    done
    grep -q "ParalTune activated\|Executing paral tune" "$LOG_FILE" 2>/dev/null && return 0
    systemctl is-active $SERVICE_NAME --quiet
}

em_assert_not_log_contains() {
    local pattern=$1
    local since=${2:-"2 min ago"}
    journalctl -u $SERVICE_NAME --since "$since" --no-pager 2>/dev/null | grep -q "$pattern" && return 1
    [ -f "$LOG_FILE" ] && grep -q "$pattern" "$LOG_FILE" 2>/dev/null && return 1
    return 0
}

em_dnf_install() {
    local pkg=$1
    if rpm -q "$pkg" >/dev/null 2>&1; then
        LOG_INFO "$pkg already installed"
        return 0
    fi
    dnf install -y "$pkg" 2>/dev/null
    if rpm -q "$pkg" >/dev/null 2>&1; then
        __EM_DNF_INSTALLED+=("$pkg")
        LOG_INFO "$pkg installed successfully"
        return 0
    fi
    LOG_WARN "$pkg installation failed"
    return 1
}

em_require_numactl() {
    command -v numactl >/dev/null 2>&1 && return 0
    em_dnf_install numactl || { LOG_WARN "numactl unavailable, skip"; return 1; }
    command -v numactl >/dev/null 2>&1 || { LOG_WARN "numactl not found after install, skip"; return 1; }
    return 0
}

em_require_stress_ng() {
    command -v stress-ng >/dev/null 2>&1 && return 0
    em_dnf_install stress-ng || { LOG_WARN "stress-ng unavailable, skip"; return 1; }
    command -v stress-ng >/dev/null 2>&1 || { LOG_WARN "stress-ng not found after install, skip"; return 1; }
    return 0
}

em_require_bc() {
    command -v bc >/dev/null 2>&1 && return 0
    em_dnf_install bc || { LOG_WARN "bc unavailable, skip"; return 1; }
    command -v bc >/dev/null 2>&1 || { LOG_WARN "bc not found after install, skip"; return 1; }
    return 0
}

em_require_spark() {
    command -v spark-submit >/dev/null 2>&1 || { LOG_WARN "spark-submit not found, skip"; return 1; }
    [ -n "$SPARK_HOME" ] || SPARK_HOME=$(dirname $(dirname $(readlink -f $(command -v spark-submit) 2>/dev/null) 2>/dev/null) 2>/dev/null)
    [ -d "$SPARK_HOME" ] || { LOG_WARN "SPARK_HOME not set/invalid, skip"; return 1; }
    return 0
}

em_dnf_remove() {
    local pkg
    for pkg in "${__EM_DNF_INSTALLED[@]:-}"; do
        [ -z "$pkg" ] && continue
        rpm -q "$pkg" >/dev/null 2>&1 && dnf remove -y "$pkg" 2>/dev/null
    done
    __EM_DNF_INSTALLED=()
}

em_get_cpu_affinity() {
    local pid=$1
    LC_ALL=C taskset -p "$pid" 2>/dev/null | awk '{print $NF}'
}

em_get_cpu_from_affinity() {
    local aff=$1
    echo "$aff" | cut -d',' -f1 | cut -d'-' -f1
}

em_get_pid_numa_node() {
    local pid=$1
    local cpu
    cpu=$(LC_ALL=C taskset -p "$pid" 2>/dev/null | awk '{print $NF}' | cut -d',' -f1 | cut -d'-' -f1)
    [ -z "$cpu" ] && echo "-1" && return
    local node
    node=$(ls -d /sys/devices/system/cpu/cpu${cpu}/node* 2>/dev/null | head -1 | grep -oP 'node\K\d+')
    echo "${node:--1}"
}
