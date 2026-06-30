#!/usr/bin/bash
# #############################################
# elasticMem mugen suite common functions (安全版 v3)
# - 精确 PID 清理，不用 killall
# - DNF 安装先检测 + 安装后校验，卸载仅限本次安装的包
# - 备份配置后逐项验证恢复
# - NUMA 检测回退到 /sys（不依赖 numactl）
# - 用例产生的后台 PID 记录到 __EM_BG_PIDS，post_test 精确清理
# - 日志断言基于"标记窗口"：em_start_service/em_mark_log 在日志文件写入唯一
#   边界标记，em_assert_*log_contains 只在标记之后的行里查找，避免跨用例污染
#   （elasticMem 经 systemd 重定向输出到文件，journalctl 里只有 systemd 生命周期
#   消息，因此断言以文件日志为准）
# - 提供便携负载生成器 em_start_cpu_load / em_start_mem_load，stress-ng 不可用
#   时用 numactl+bash/python 替代
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
em_LOG_MARK=""
em_LAST_PID=""

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
            # Parse range format: "0-3" → 4, "0,2-3" → 3, "0,1" → 2
            count=0
            local IFS=','
            for part in $online; do
                if echo "$part" | grep -q '-'; then
                    local s=$(echo "$part" | cut -d'-' -f1)
                    local e=$(echo "$part" | cut -d'-' -f2)
                    count=$((count + e - s + 1))
                else
                    count=$((count + 1))
                fi
            done
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
    systemctl show $SERVICE_NAME -p MainPID --value 2>/dev/null
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

# ---- 日志窗口（标记/时间窗）-----------------------------------------------
# 在日志文件中写入唯一边界标记，后续 em_assert_*log_contains 只查找该标记之后的行，
# 彻底避免跨用例日志污染。elasticMem 输出经 systemd 重定向到 $LOG_FILE（append），
# 因此标记与服务日志共处同一文件，边界可靠。
em_mark_log() {
    em_LOG_MARK="EMTESTMARK_$$_$(date +%s)_$RANDOM"
    [ -d "$LOG_DIR" ] || mkdir -p "$LOG_DIR" 2>/dev/null
    printf '[%s] [INFO] %s test-boundary\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$em_LOG_MARK" >> "$LOG_FILE" 2>/dev/null
}

# 把 "N min/sec ago" 转成绝对时间戳 "YYYY-MM-DD HH:MM:SS"
em_log_since_ts() {
    local since=${1:-"2 min ago"}
    local s
    s=$(echo "$since" | sed -E 's/[[:space:]]*ago[[:space:]]*$//; s/^[[:space:]]+//; s/[[:space:]]+$//')
    local n u
    n=$(echo "$s" | awk '{print $1}')
    u=$(echo "$s" | awk '{print $2}')
    n=${n:-2}; u=${u:-min}
    case "$u" in
        sec|secs|second|seconds) date -d "-${n} seconds" "+%Y-%m-%d %H:%M:%S" 2>/dev/null ;;
        min|mins|minute|minutes) date -d "-${n} minutes" "+%Y-%m-%d %H:%M:%S" 2>/dev/null ;;
        hour|hours)              date -d "-${n} hours"   "+%Y-%m-%d %H:%M:%S" 2>/dev/null ;;
        *)                       date -d "$since"        "+%Y-%m-%d %H:%M:%S" 2>/dev/null ;;
    esac
}

# 打印本用例相关的日志行：有标记则取标记之后；否则取 since 时间窗内的行
em_log_window() {
    local since=${1:-"2 min ago"}
    [ -f "$LOG_FILE" ] || return 0
    if [ -n "$em_LOG_MARK" ]; then
        awk -v m="$em_LOG_MARK" 'index($0,m){f=1;next} f{print}' "$LOG_FILE" 2>/dev/null
    else
        local cutoff
        cutoff=$(em_log_since_ts "$since")
        if [ -z "$cutoff" ]; then
            tail -n 4000 "$LOG_FILE" 2>/dev/null
        else
            awk -v c="$cutoff" '
                /^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\]/ {
                    ts=substr($0,2,19); if (ts>=c) f=1
                }
                { if (f) print }
            ' "$LOG_FILE" 2>/dev/null
        fi
    fi
}

# 统计本用例日志中匹配 pattern 的行数（pattern 为空则统计全部行数）
em_log_count() {
    local pattern=${1:-}
    if [ -z "$pattern" ]; then
        em_log_window | wc -l 2>/dev/null
    else
        em_log_window | grep -c -- "$pattern" 2>/dev/null
    fi
}

em_assert_log_contains() {
    local pattern=$1
    local since=${2:-"2 min ago"}
    if em_log_window "$since" | grep -q -- "$pattern" 2>/dev/null; then
        return 0
    fi
    # 兜底：journalctl（elasticMem 自身不写 journal，通常无命中，保留以防万一）
    if journalctl -u $SERVICE_NAME --since "$since" --no-pager 2>/dev/null | grep -q -- "$pattern" 2>/dev/null; then
        return 0
    fi
    return 1
}

em_assert_not_log_contains() {
    local pattern=$1
    local since=${2:-"2 min ago"}
    if em_log_window "$since" | grep -q -- "$pattern" 2>/dev/null; then
        return 1
    fi
    if journalctl -u $SERVICE_NAME --since "$since" --no-pager 2>/dev/null | grep -q -- "$pattern" 2>/dev/null; then
        return 1
    fi
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

em_start_service() {
    mkdir -p "$LOG_DIR" 2>/dev/null
    em_mark_log
    systemctl daemon-reload 2>/dev/null
    systemctl restart $SERVICE_NAME 2>/dev/null
    sleep 3
    systemctl is-active $SERVICE_NAME --quiet
}

# ---- 便携负载生成器（stress-ng 不可用时替代）------------------------------
# 启动 count 个 CPU 级旋进程，node 为空则不绑 NUMA；记录到 em_LAST_PID 并入清理队列
em_start_cpu_load() {
    local node="$1" count="${2:-1}" timeout="${3:-60}"
    local prefix="" i
    [ -n "$node" ] && prefix="numactl --cpunodebind=$node --membind=$node"
    for ((i=0; i<count; i++)); do
        $prefix bash -c 'end=$((SECONDS+$1)); while [ $SECONDS -lt $end ]; do :; done' bash "$timeout" &
        em_LAST_PID=$!
        em_track_pid "$em_LAST_PID"
    done
}

# 启动一个在 node 上分配 bytes 内存的进程并保持 timeout 秒；记录到 em_LAST_PID
em_start_mem_load() {
    local node="${1:-0}" bytes="${2:-1073741824}" timeout="${3:-120}"
    case "$bytes" in
        *G|*g) bytes=$(( ${bytes%[Gg]} * 1073741824 )) ;;
        *M|*m) bytes=$(( ${bytes%[Mm]} * 1048576 )) ;;
    esac
    numactl --cpunodebind="$node" --membind="$node" python3 -c '
import mmap, time, sys
s = int(sys.argv[1])
m = mmap.mmap(-1, s)
blk = b"x" * (1 << 20)
for o in range(0, s, 1 << 20):
    m[o:o+len(blk)] = blk
time.sleep(int(sys.argv[2]))
' "$bytes" "$timeout" &
    em_LAST_PID=$!
    em_track_pid "$em_LAST_PID"
}
