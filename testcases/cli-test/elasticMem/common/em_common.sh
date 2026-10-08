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
# @Author    :   xu_yishen
# @Contact   :   xuyishen3@huawei.com
# @Date      :   2026/06/30
# @License   :   Mulan PSL v2
# @Desc      :   common function library for the elasticMem test suite
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# shared constants
CONFIG_PATH="/etc/elasticMem.ini"
CONFIG_BAK="/etc/elasticMem.ini.mugen_bak"
LOG_DIR="/var/log/elasticMem"
LOG_FILE="$LOG_DIR/elasticMem.log"
SERVICE_NAME="elasticMem"
export CGROUP_BASE="/sys/fs/cgroup/cpuset"

# background pids spawned by a case, cleaned up in post_test
__EM_BG_PIDS=()
# packages installed during a case, removed in post_test
__EM_DNF_INSTALLED=()
# line count of $LOG_FILE at the start of the current assertion window
em_LOG_START=0

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
    [ "${#__EM_BG_PIDS[@]}" -eq 0 ] && return 0
    local pid
    for pid in "${__EM_BG_PIDS[@]}"; do
        [ -z "$pid" ] && continue
        em_safe_kill "$pid"
    done
    SLEEP_WAIT 3
    for pid in "${__EM_BG_PIDS[@]}"; do
        [ -z "$pid" ] && continue
        em_safe_kill "$pid" >/dev/null 2>&1
        kill -0 "$pid" 2>/dev/null && kill -KILL "$pid" 2>/dev/null
    done
    __EM_BG_PIDS=()
}

em_backup_config() {
    [ -f "$CONFIG_PATH" ] && cp -fp "$CONFIG_PATH" "$CONFIG_BAK"
}

em_restore_config() {
    [ -f "$CONFIG_BAK" ] && cp -fp "$CONFIG_BAK" "$CONFIG_PATH" 2>/dev/null && rm -f "$CONFIG_BAK"
}

em_stop_service() {
    systemctl stop "$SERVICE_NAME" 2>/dev/null
    SLEEP_WAIT 2
    local p
    for p in $(pgrep -x elasticMem 2>/dev/null); do em_safe_kill "$p"; done
    SLEEP_WAIT 1
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
        local online
        online=$(cat /sys/devices/system/node/online 2>/dev/null)
        if [ -n "$online" ]; then
            # Parse "0-3" -> 4, "0,2-3" -> 3, "0,1" -> 2
            count=0
            local IFS=','
            for part in $online; do
                if echo "$part" | grep -q '-'; then
                    local s e
                    s=$(echo "$part" | cut -d'-' -f1)
                    e=$(echo "$part" | cut -d'-' -f2)
                    count=$((count + e - s + 1))
                else
                    count=$((count + 1))
                fi
            done
        else
            count=$(find /sys/devices/system/node -maxdepth 1 -name 'node*' 2>/dev/null | wc -l)
        fi
    fi
    echo "$count"
}

em_check_env() {
    local numa_count
    numa_count=$(em_get_numa_count)
    if [ -z "$numa_count" ] || ! [[ "$numa_count" =~ ^[0-9]+$ ]] || [ "$numa_count" -lt 2 ]; then
        LOG_WARN "NUMA nodes < 2 ($numa_count), skip test"
        return 1
    fi
    test -d /sys/devices/system/node/node0 || {
        LOG_WARN "No NUMA node0 found, skip test"
        return 1
    }
    return 0
}

em_get_service_pid() {
    systemctl show "$SERVICE_NAME" -p MainPID --value 2>/dev/null
}

# Print the NUMA node id (0-based) a process is bound to, derived from the
# first CPU in its affinity list (taskset -cp list format). Returns the node
# via stdout and 0 on success; prints nothing and returns 1 when the affinity
# cannot be resolved (unbound process, taskset missing). Pure reader: callers
# assert on the returned value; this helper never calls CHECK_RESULT.
em_pid_node() {
    local pid=$1
    local list cpu node _nl
    list=$(LC_ALL=C taskset -cp "$pid" 2>/dev/null | awk -F': ' '{print $2}')
    cpu=${list%%,*}
    cpu=${cpu%%-*}
    [[ "$cpu" =~ ^[0-9]+$ ]] || return 1
    shopt -s nullglob
    _nl=(/sys/devices/system/cpu/cpu"$cpu"/node*)
    shopt -u nullglob
    node=${_nl[0]}
    [ -n "$node" ] || return 1
    echo "${node##*node}"
}

# Write a paral policy config. Optional 3rd/4th arguments enable the capacity
# scheduling feature added in v1.0.0; when omitted the config is identical to
# the legacy form (capacity_scheduling defaults to false inside elasticMem),
# so existing callers are unaffected.
#   $1 whitelist            default [test]
#   $2 nr_cpus              default 1
#   $3 capacity_scheduling  "true"|"false" or empty (omit line)
#   $4 numa_capacity_weights e.g. "[3,1,3,1]" or empty (omit line)
em_write_paral_config() {
    local whitelist=${1:-[test]}
    local nr_cpus=${2:-1}
    local capacity_scheduling=${3:-}
    local numa_capacity_weights=${4:-}
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
    local rc=$?
    [ -n "$capacity_scheduling" ] && printf 'capacity_scheduling = %s\n' "$capacity_scheduling" >> "$CONFIG_PATH"
    [ -n "$numa_capacity_weights" ] && printf 'numa_capacity_weights = %s\n' "$numa_capacity_weights" >> "$CONFIG_PATH"
    CHECK_RESULT "$rc" 0 0 "failed to write paral config"
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
    CHECK_RESULT $? 0 0 "failed to write light config"
}

# Record the current line count of $LOG_FILE as the boundary for later log
# assertions. elasticMem appends its output to $LOG_FILE, so all lines written
# after this point belong to the current case (no cross-case contamination).
em_mark_log() {
    em_LOG_START=0
    [ -f "$LOG_FILE" ] && em_LOG_START=$(wc -l < "$LOG_FILE")
}

# Print the $LOG_FILE lines written after the last em_mark_log boundary.
em_log_window() {
    [ -f "$LOG_FILE" ] || return 0
    tail -n +$((em_LOG_START + 1)) "$LOG_FILE" 2>/dev/null
}

# Count log lines (after the boundary) matching pattern; count all if empty.
em_log_count() {
    local pattern=${1:-}
    if [ -z "$pattern" ]; then
        em_log_window | wc -l
    else
        em_log_window | grep -c -- "$pattern"
    fi
}

# Assert the elasticMem log (after the boundary) contains pattern.
em_assert_log_contains() {
    local pattern=$1
    local msg=${2:-"expected log not found: $1"}
    em_log_window | grep -q -- "$pattern" 2>/dev/null
    CHECK_RESULT $? 0 0 "$msg"
}

# Assert the elasticMem log (after the boundary) does NOT contain pattern.
em_assert_not_log_contains() {
    local pattern=$1
    local msg=${2:-"unexpected log found: $1"}
    if em_log_window | grep -q -- "$pattern" 2>/dev/null; then
        CHECK_RESULT 1 0 0 "$msg"
    else
        CHECK_RESULT 0 0 0 "$msg"
    fi
}

em_dnf_install() {
    local pkg=$1
    if rpm -q "$pkg" >/dev/null 2>&1; then
        return 0
    fi
    dnf install -y "$pkg" 2>/dev/null
    if rpm -q "$pkg" >/dev/null 2>&1; then
        __EM_DNF_INSTALLED+=("$pkg")
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

em_dnf_remove() {
    local pkg
    for pkg in "${__EM_DNF_INSTALLED[@]:-}"; do
        [ -z "$pkg" ] && continue
        rpm -q "$pkg" >/dev/null 2>&1 && dnf remove -y "$pkg" 2>/dev/null
    done
    __EM_DNF_INSTALLED=()
}

# Source: https://atomgit.com/kunpengcompute/src-elasticMem (prebuilt binary; the built
# rpm is cached under ~/rpmbuild/RPMS so the clone+build runs only once across the suite).
em_install_elasticmem() {
    rpm -q elasticMem >/dev/null 2>&1 && return 0
    command -v rpmbuild >/dev/null 2>&1 || dnf install -y rpm-build >/dev/null 2>&1
    command -v rpmbuild >/dev/null 2>&1 || { LOG_WARN "rpmbuild unavailable"; return 1; }
    command -v git >/dev/null 2>&1 || dnf install -y git >/dev/null 2>&1
    command -v git >/dev/null 2>&1 || { LOG_WARN "git unavailable"; return 1; }
    shopt -s nullglob
    local rpms=("$HOME/rpmbuild/RPMS/"*/elasticMem-*.rpm)
    shopt -u nullglob
    local rpm="${rpms[0]:-}"
    if [ -z "$rpm" ]; then
        local src="/tmp/elasticMem-src"
        rm -rf "$src"
        git clone --depth 1 https://atomgit.com/kunpengcompute/src-elasticMem "$src" || { LOG_WARN "git clone failed"; return 1; }
        mkdir -p "$HOME/rpmbuild/SOURCES" "$HOME/rpmbuild/SPECS"
        cp "$src"/elasticMem-*.tar.gz "$HOME/rpmbuild/SOURCES/" || { LOG_WARN "cp tarball failed"; return 1; }
        cp "$src"/elasticMem.spec "$HOME/rpmbuild/SPECS/" || { LOG_WARN "cp spec failed"; return 1; }
        (cd "$HOME/rpmbuild/SPECS" && rpmbuild -ba elasticMem.spec) || { LOG_WARN "rpmbuild failed"; return 1; }
        shopt -s nullglob
        rpms=("$HOME/rpmbuild/RPMS/"*/elasticMem-*.rpm)
        shopt -u nullglob
        rpm="${rpms[0]:-}"
    fi
    [ -n "$rpm" ] || { LOG_WARN "no rpm built"; return 1; }
    dnf install -y "$rpm" >/dev/null 2>&1 || { LOG_WARN "dnf install failed"; return 1; }
    rpm -q elasticMem >/dev/null 2>&1 || { LOG_WARN "elasticMem not installed after dnf install"; return 1; }
    return 0
}

em_remove_elasticmem() {
    rpm -q elasticMem >/dev/null 2>&1 && dnf remove -y elasticMem >/dev/null 2>&1
    return 0
}


# Start 'count' CPU-spinning processes; empty 'node' means no NUMA pinning.
# Used as a portable fallback when stress-ng is unavailable.
em_start_cpu_load() {
    local node="$1" count="${2:-1}" timeout="${3:-60}" prefix=() i
    [ -n "$node" ] && prefix=(numactl "--cpunodebind=$node" "--membind=$node")
    for ((i = 0; i < count; i++)); do
        EM_TIMEOUT="$timeout" "${prefix[@]}" bash -c '(( end = SECONDS + EM_TIMEOUT )); while (( SECONDS < end )); do :; done' &
        em_track_pid "$!"
    done
}

em_start_service() {
    local msg=${1:-"elasticMem service start failed"}
    mkdir -p "$LOG_DIR"
    em_mark_log
    systemctl daemon-reload 2>/dev/null
    systemctl restart "$SERVICE_NAME" 2>/dev/null
    SLEEP_WAIT 3
    systemctl is-active "$SERVICE_NAME" --quiet
    CHECK_RESULT $? 0 0 "$msg"
}
