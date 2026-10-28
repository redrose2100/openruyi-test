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

function LOG_INFO() {
    message=${*-"Developer does not write the log messages."}
    python3 "${OET_PATH}"/libs/locallibs/mugen_log.py --level 'info' --message "$message"
}

function LOG_WARN() {
    message=${*-"Developer does not write the log messages."}
    python3 "${OET_PATH}"/libs/locallibs/mugen_log.py --level 'warn' --message "$message"
}

function LOG_DEBUG() {
    message=${*-"Developer does not write the log messages."}
    python3 "${OET_PATH}"/libs/locallibs/mugen_log.py --level 'debug' --message "$message"
}

function LOG_ERROR() {
    message=${*-"Developer does not write the log messages."}
    python3 "${OET_PATH}"/libs/locallibs/mugen_log.py --level 'error' --message "$message"
}

# ---------------------------------------------------------------------------
# Non-root privilege escalation helpers.
#
# These mirror libs/locallibs/ssh_cmd.py so the python and shell layers behave
# identically: same detection ladder, same base64 + temp-script wrapping, same
# /tmp/.mgn_ prefix. Keep them in sync.
# ---------------------------------------------------------------------------
MUGEN_SUDO_TMP_PREFIX="/tmp/.mgn_"
MUGEN_SUDO_PROMPT="MUGEN_SUDO_PWD:"
MUGEN_PRIV_CACHE_TTL=3600

# Resolve the configured SUDO_MODE for a given ip/port by matching the NODE<n>_*
# blocks, then fall back to the global MUGEN_SUDO_MODE, then "auto".
function _mugen_sudo_conf() {
    local _ip=$1
    local _port=${2-22}
    local _n _nip _nport _mode

    for _n in 1 2 3 4 5 6 7 8 9; do
        eval "_nip=\${NODE${_n}_IPV4-}"
        [ "${_nip}"x = "${_ip}"x ] || continue
        eval "_nport=\${NODE${_n}_SSH_PORT-22}"
        [ "${_nport}"x = "${_port}"x ] || continue
        eval "_mode=\${NODE${_n}_SUDO_MODE-}"
        if [ -n "${_mode}" ]; then
            printf '%s' "${_mode}"
            return 0
        fi
        break
    done

    printf '%s' "${MUGEN_SUDO_MODE-auto}"
}

function _mugen_priv_cache_file() {
    local _ip=$1
    local _port=$2
    local _user=$3
    printf '%s' "${TMPDIR:-/tmp}/.mugen_priv.${_ip}_${_port}_${_user}"
}

# Echo the cached privilege mode, or nothing when the cache is missing/stale.
function _mugen_priv_cache_get() {
    local _f
    _f=$(_mugen_priv_cache_file "$1" "$2" "$3")
    [ -f "${_f}" ] || return 1

    local _now _ts
    _now=$(date +%s)
    _ts=$(head -n 1 "${_f}" 2>/dev/null)
    case "${_ts}" in
    '' | *[!0-9]*) return 1 ;;
    esac
    [ $((_now - _ts)) -gt "${MUGEN_PRIV_CACHE_TTL}" ] && return 1

    sed -n '2p' "${_f}" 2>/dev/null
}

function _mugen_priv_cache_put() {
    local _f
    _f=$(_mugen_priv_cache_file "$1" "$2" "$3")
    printf '%s\n%s\n' "$(date +%s)" "$4" >"${_f}" 2>/dev/null || true
}

# Decide how to run remote commands for this node.
# Prints one of: root | none | nopasswd | password | unavailable
function _mugen_resolve_privilege() {
    local _ip=$1
    local _port=${2-22}
    local _user=${3-root}
    local _pwd=${4-}

    # root logins short circuit without any remote round trip
    if [ "${_user}"x = "root"x ]; then
        printf '%s' "root"
        return 0
    fi

    local _configured
    _configured=$(_mugen_sudo_conf "${_ip}" "${_port}")
    if [ "${_configured}"x = "none"x ]; then
        printf '%s' "none"
        return 0
    fi
    # an explicit non-auto mode wins over probing
    case "${_configured}" in
    nopasswd | password | unavailable)
        printf '%s' "${_configured}"
        return 0
        ;;
    esac

    local _cached
    if _cached=$(_mugen_priv_cache_get "${_ip}" "${_port}" "${_user}"); then
        [ -n "${_cached}" ] && {
            printf '%s' "${_cached}"
            return 0
        }
    fi

    local _mode="unavailable"
    local _uid
    _uid=$(bash "${OET_PATH}"/libs/locallibs/sshcmd.sh -c "id -u" -i "${_ip}" \
        -u "${_user}" -p "${_pwd}" -t 30 -o "${_port}" 2>/dev/null)
    _uid=$(printf '%s' "${_uid}" | tr -d ' \r\n')
    if [ "${_uid}"x = "0"x ]; then
        _mode="root"
    else
        bash "${OET_PATH}"/libs/locallibs/sshcmd.sh -c "sudo -n true" -i "${_ip}" \
            -u "${_user}" -p "${_pwd}" -t 30 -o "${_port}" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            _mode="nopasswd"
        elif [ -n "${_pwd}" ]; then
            # a ticket may be unavailable, but the password could still work
            _mode="password"
        fi
    fi

    _mugen_priv_cache_put "${_ip}" "${_port}" "${_user}" "${_mode}"
    printf '%s' "${_mode}"
}

# Base64 payload + temp file. Byte-compatible with ssh_cmd.py wrap_cmd().
function _mugen_sudo_wrap() {
    local _cmd=$1
    local _mode=${2-root}

    if [ "${_mode}"x = "root"x ] || [ "${_mode}"x = "none"x ] || [ -z "${_mode}" ]; then
        printf '%s' "${_cmd}"
        return 0
    fi

    local _payload _sudo_call
    _payload=$(printf '%s' "${_cmd}" | base64 -w 0)
    if [ "${_mode}"x = "nopasswd"x ]; then
        _sudo_call="sudo -n -H sh \$T"
    else
        _sudo_call="sudo -S -p '${MUGEN_SUDO_PROMPT}' -H sh \$T"
    fi

    printf '%s' "umask 077; T=\$(mktemp ${MUGEN_SUDO_TMP_PREFIX}XXXXXX 2>/dev/null) || T=${MUGEN_SUDO_TMP_PREFIX}\$\$; printf '%s' '${_payload}' | base64 -d > \$T; ${_sudo_call}; r=\$?; rm -f \$T; exit \$r"
}

function SSH_CMD() {
    cmd=$1
    remoteip=$2
    remotepasswd=${3-openEuler12#$}
    remoteuser=${4-root}
    timeout=${5-300}
    connport=${6-22}

    # root logins keep the legacy call shape untouched (zero regression)
    if [ "${remoteuser}"x = "root"x ]; then
        bash "${OET_PATH}"/libs/locallibs/sshcmd.sh -c "$cmd" -i "$remoteip" -u "$remoteuser" -p "$remotepasswd" -t "$timeout" -o "$connport"
        ret=$?
        test $ret -ne 0 && LOG_ERROR "Failed in remote CMD operation:$ret"
        return $ret
    fi

    sudo_mode=$(_mugen_resolve_privilege "$remoteip" "$connport" "$remoteuser" "$remotepasswd")
    if [ "${sudo_mode}"x = "unavailable"x ]; then
        LOG_ERROR "Neither root login nor passwordless sudo is available on $remoteip for user $remoteuser."
        return 1
    fi

    bash "${OET_PATH}"/libs/locallibs/sshcmd.sh -c "$cmd" -i "$remoteip" -u "$remoteuser" -p "$remotepasswd" -t "$timeout" -o "$connport" -s "$sudo_mode" -w "$remotepasswd"
    ret=$?
    test $ret -ne 0 && LOG_ERROR "Failed in remote CMD operation:$ret"
    return $ret
}

function SSH_SCP() {
    src=$1
    dest=$2
    remotepasswd=${3-openEuler12#$}
    connport=${4-22}
    # 可选的远端登录用户：src/dest 中若省略 "user@" 则用它补全，
    # 便于非 root 登录场景不把用户名硬编码在路径里。
    remoteuser=${5-}

    if [ -n "${remoteuser}" ]; then
        if printf '%s' "$src" | grep -q ':' && ! printf '%s' "$src" | grep -q '@'; then
            src="${remoteuser}@${src}"
        fi
        if printf '%s' "$dest" | grep -q ':' && ! printf '%s' "$dest" | grep -q '@'; then
            dest="${remoteuser}@${dest}"
        fi
    fi

    bash "${OET_PATH}"/libs/locallibs/sshscp.sh -p "$remotepasswd" -o "$connport" -s "$src" -d "$dest"
    ret=$?
    test $ret -ne 0 && LOG_ERROR "Failed in remote SCP operation: $ret"
    return $ret
}

function P_SSH_CMD() {
    python3 "${OET_PATH}"/libs/locallibs/ssh_cmd.py "$@"
}

function SFTP() {
    python3 "${OET_PATH}"/libs/locallibs/sftp.py "$@"
}

function TEST_NIC() {
    id=${1-1}
    python3 "${OET_PATH}"/libs/locallibs/get_test_device.py \
        --device nic --node "$id"
}

function TEST_DISK() {
    id=${1-1}
    python3 "${OET_PATH}"/libs/locallibs/get_test_device.py \
        --device disk --node "$id"
}

function DNF_INSTALL() {
    pkgs=$1
    node=${2-1}
    #多节点初始系统环境相同，本地和远端安装的包，在任何节点不不应该存在
    [ -z "$tmpfile" ] && tmpfile=""

    tmpfile2=$(python3 "${OET_PATH}"/libs/locallibs/rpm_manage.py \
        install --pkgs "$pkgs" --node "$node" --tempfile "$tmpfile")

    [ -z "$tmpfile" ] && tmpfile=$tmpfile2
}

function DNF_REMOVE() {
    node=${1-1}
    pkg_list=${2-""}
    mode=${3-0}

    if [[ -z "$tmpfile" && -z "$pkg_list" ]]; then
        LOG_WARN "no thing to do."
        return 0
    fi

    [ "$mode" -ne 0 ] && {
        tmpf=$tmpfile
        tmpfile=""
    }

    if [ "$node" == 0 ]; then
        node_num=$(python3 "${OET_PATH}"/libs/locallibs/read_conf.py node-num)

        for node_id in $(seq 1 "$node_num"); do
            python3 "${OET_PATH}"/libs/locallibs/rpm_manage.py \
                remove --node "$node_id" --pkgs "$pkg_list" --tempfile "$tmpfile"
        done
    else
        python3 "${OET_PATH}"/libs/locallibs/rpm_manage.py \
            remove --node "$node" --pkgs "$pkg_list" --tempfile "$tmpfile"
    fi

    [ "$mode" -ne 0 ] && {
        tmpfile=$tmpf
    }
}

function GET_FREE_PORT() {
    ip=${1-""}
    start_port=${2-1000}
    end_port=${3-10000}
    python3 "${OET_PATH}"/libs/locallibs/free_port.py \
        get --ip "$ip" --start "$start_port" --end "$end_port"
}

function IS_FREE_PORT() {
    port=$1
    ip=${2-""}
    python3 "${OET_PATH}"/libs/locallibs/free_port.py \
        check --port "$port" --ip "$ip"
}

function REMOTE_REBOOT() {
    node=${1-2}
    waittime=${2-""}
    if [ "$waittime"x != ""x ]; then
        python3 "${OET_PATH}"/libs/locallibs/remote_reboot.py "reboot" --node "$node" --waittime "$waittime"
    else
        python3 "${OET_PATH}"/libs/locallibs/remote_reboot.py "reboot" --node "$node"
    fi
}

function REMOTE_REBOOT_WAIT() {
    node=${1-2}
    waittime=${2-""}
    if [ "$waittime"x != ""x ]; then
        python3 "${OET_PATH}"/libs/locallibs/remote_reboot.py "wait" --node "$node" --waittime "$waittime"
    else
        python3 "${OET_PATH}"/libs/locallibs/remote_reboot.py "wait" --node "$node"
    fi
}

function SLEEP_WAIT() {
    wait_time=$1
    cmd=$2
    mode=${3-1}
    idle_timeout=${4-120}
    python3 "${OET_PATH}"/libs/locallibs/sleep_wait.py --time "$wait_time" --cmd "$cmd" --mode "$mode" --idle-timeout "$idle_timeout"
}

function CHECK_ENV() {
    suite_json=$1
    test_case=$2
    python3 "${OET_PATH}"/libs/locallibs/check_environment.py --suite_file "$suite_json" --case "$test_case"
}
