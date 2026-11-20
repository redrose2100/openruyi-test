#!/usr/bin/bash
# Copyright (c) [2020] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   lemon.higgins
#@Contact   	:   lemon.higgins@aliyun.com
#@Date      	:   2020-04-09 09:39:43
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Public function
#####################################

function LOG_INFO() {
    printf "$(date +%Y-%m-%d\ %T)  $0  [ INFO  ]  %s\n" "$@"
}

function LOG_WARN() {
    printf "$(date +%Y-%m-%d\ %T)  $0  [ WARN  ]  %s\n" "$@"
}

function LOG_ERROR() {
    printf "$(date +%Y-%m-%d\ %T)  $0  [ ERROR ]  %s\n" "$@"
}

# ---------------------------------------------------------------------------
# Non-root privilege escalation helpers (expect-only fallback layer).
# Mirrors _mugen_* in common_lib_python.sh and ssh_cmd.py.
# ---------------------------------------------------------------------------
MUGEN_SUDO_TMP_PREFIX="/tmp/.mgn_"
MUGEN_SUDO_PROMPT="MUGEN_SUDO_PWD:"
MUGEN_PRIV_CACHE_TTL=3600

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
    printf '%s' "${TMPDIR:-/tmp}/.mugen_priv.$1_$2_$3"
}

function _mugen_priv_cache_get() {
    local _f _now _ts
    _f=$(_mugen_priv_cache_file "$1" "$2" "$3")
    [ -f "${_f}" ] || return 1
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

# Prints: root | none | nopasswd | password | unavailable
function _mugen_resolve_privilege() {
    local _ip=$1
    local _port=${2-22}
    local _user=${3-root}
    local _pwd=${4-}

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
        if bash "${OET_PATH}"/libs/locallibs/sshcmd.sh -c "sudo -n true" -i "${_ip}" \
            -u "${_user}" -p "${_pwd}" -t 30 -o "${_port}" >/dev/null 2>&1; then
            _mode="nopasswd"
        elif [ -n "${_pwd}" ]; then
            _mode="password"
        fi
    fi

    _mugen_priv_cache_put "${_ip}" "${_port}" "${_user}" "${_mode}"
    printf '%s' "${_mode}"
}

function SSH_CMD() {
    expect -v
    if [ $? -ne 0 ]; then
        LOG_ERROR "System not support expect, not support SSH_CMD"
        return 1
    fi
    cmd=$1
    remoteip=$2
    remotepasswd=${3-openEuler12#$}
    remoteuser=${4-root}
    timeout=${5-300}
    connport=${6-22}

    # root logins keep the legacy call shape untouched (zero regression)
    if [ "${remoteuser}"x = "root"x ]; then
        bash ${OET_PATH}/libs/locallibs/sshcmd.sh -c "$cmd" -i "$remoteip" -u "$remoteuser" -p "$remotepasswd" -t "$timeout" -o "$connport"
        ret=$?
        test $ret -ne 0 && LOG_ERROR "Failed in remote CMD operation:$ret"
        return $ret
    fi

    sudo_mode=$(_mugen_resolve_privilege "$remoteip" "$connport" "$remoteuser" "$remotepasswd")
    if [ "${sudo_mode}"x = "unavailable"x ]; then
        LOG_ERROR "Neither root login nor passwordless sudo is available on $remoteip for user $remoteuser."
        return 1
    fi

    bash ${OET_PATH}/libs/locallibs/sshcmd.sh -c "$cmd" -i "$remoteip" -u "$remoteuser" -p "$remotepasswd" -t "$timeout" -o "$connport" -s "$sudo_mode" -w "$remotepasswd"
    ret=$?
    test $ret -ne 0 && LOG_ERROR "Failed in remote CMD operation:$ret"
    return $ret
}

function SSH_SCP() {
    expect -v
    if [ $? -ne 0 ]; then
        LOG_ERROR "System not support expect, not support SSH_SCP"
        return 1
    fi
    src=$1
    dest=$2
    remotepasswd=${3-openEuler12#$}
    connport=${4-22}
    # Optional 5th arg: remote login user, used to complete "user@" when the
    # caller leaves it out (keeps non-root call sites free of hardcoded names).
    remoteuser=${5-}

    if [ -n "${remoteuser}" ]; then
        if printf '%s' "$src" | grep -q ':' && ! printf '%s' "$src" | grep -q '@'; then
            src="${remoteuser}@${src}"
        fi
        if printf '%s' "$dest" | grep -q ':' && ! printf '%s' "$dest" | grep -q '@'; then
            dest="${remoteuser}@${dest}"
        fi
    fi

    bash ${OET_PATH}/libs/locallibs/sshscp.sh -p "$remotepasswd" -o "$connport" -s "$src" -d "$dest"
    ret=$?
    test $ret -ne 0 && LOG_ERROR "Failed in remote SCP operation: $ret"
    return $ret
}

function P_SSH_CMD() {
    LOG_ERROR "python3 not find, not support P_SSH_CMD"
    exit 1
}

function SFTP() {
    LOG_ERROR "python3 not find, not support SFTP"
    exit 1
}

function TEST_NIC() {
    LOG_ERROR "python3 not find, not support TEST_NIC"
    exit 1
}

function TEST_DISK() {
    LOG_ERROR "python3 not find, not support TEST_DISK"
    exit 1
}

function DNF_INSTALL() {
    dnf --version
    if [ $? -ne 0 ]; then
        LOG_ERROR "system not find have dnf, not support DNF_INSTALL"
        return 1
    fi
    __pkg_list=$1
    node=${2-1}
    if [ -z "${__pkg_list}" ]; then
        LOG_ERROR "Wrong parameter."
        exit 1
    fi

    eval "location=\${NODE${node}_LOCALTION-}"
    if [[ ${location} == "local" ]]; then
        reponames=$(grep '^\[.*\]' /etc/yum.repos.d/*.repo | tr -d [] | sed -e ':a;N;$!ba;s/\n/ /g')
        mapfile -t __install_pkgs < <(dnf --assumeno install ${__pkg_list[*]} 2>&1 | grep -wE "${reponames// /|}" | grep -wE "$(uname -m)|noarch" | awk '{print $1}')
        dnf -y install ${__pkg_list[*]}

        if ! dnf -y install ${__pkg_list[*]}; then
            LOG_ERROR "pkg_list:${__pkg_list[*]} install failed."
            exit 1
        fi
    else
        eval "remoteIp=\${NODE${node}_IPV4-}"
        eval "password=\${NODE${node}_PASSWORD-}"
        eval "ssh_port=\${NODE${node}_SSH_PORT-22}"
        eval "remoteUser=\${NODE${node}_USER-root}"
        cmd="dnf -y install ${__pkg_list[*]}"

        SSH_CMD "$cmd" "$remoteIp" "$password" "$remoteUser" 300 "$ssh_port"
        ret=$?

        if [ "$ret" -ne 0 ]; then
            LOG_ERROR "pkg_list:${__pkg_list[*]} install failed."
            exit 1
        fi
    fi

    __installed_pkgs+=" ${__install_pkgs[*]}"

    return 0
}

function DNF_REMOVE() {
    dnf --version
    if [ $? -ne 0 ]; then
        LOG_ERROR "system not find have dnf, not support DNF_INSTALL"
        return 1
    fi

    node=${1-1}
    __pkg_list=${2-""}
    mode=${3-0}

    if [[ -z "$__installed_pkgs" && -z "$pkg_list" ]]; then
        LOG_WARN "no thing to do."
        return 0
    fi

    [ $mode -ne 0 ] && {
        tmpf=$__installed_pkgs
        __installed_pkgs=""
    }

    node_number=$(env | grep -E "NODE[0-9]+=" | wc -l)

    if [ "$node" -eq 0 ]; then
        for node_id in $(seq 1 $node_number); do
            eval "location=\${NODE${node_id}_LOCALTION-}"
            if [[ ${location} == "local" ]]; then
                if ! dnf -y remove ${__installed_pkgs[*]} ${__pkg_list[*]}; then
                    LOG_ERROR "pkg_list:${__installed_pkgs[*]} ${__pkg_list[*]} remove failed."
                    exit 1
                fi
            else
                eval "remoteIp=\${NODE${node_id}_IPV4-}"
                eval "password=\${NODE${node_id}_PASSWORD-}"
                eval "ssh_port=\${NODE${node_id}_SSH_PORT-22}"
                eval "remoteUser=\${NODE${node_id}_USER-root}"
                cmd="dnf -y remove ${__installed_pkgs[*]} ${__pkg_list[*]}"

                SSH_CMD "$cmd" "$remoteIp" "$password" "$remoteUser" 300 "$ssh_port"
                ret=$?

                if [ "$ret" -ne 0 ]; then
                    LOG_ERROR "pkg_list:${__pkg_list[*]} remove failed."
                    exit 1
                fi
            fi
        done
    else
        eval "location=\${NODE${node}_LOCALTION-}"
        if [[ ${location} == "local" ]]; then
            if ! dnf -y remove ${__installed_pkgs[*]} ${__pkg_list[*]}; then
                LOG_ERROR "pkg_list:${__installed_pkgs[*]} ${__pkg_list[*]} remove failed."
                exit 1
            fi
        else
            eval "remoteIp=\${NODE${node}_IPV4-}"
            eval "password=\${NODE${node}_PASSWORD-}"
            eval "ssh_port=\${NODE${node}_SSH_PORT-22}"
            eval "remoteUser=\${NODE${node}_USER-root}"
            cmd="dnf -y remove ${__installed_pkgs[*]} ${__pkg_list[*]}"

            SSH_CMD "$cmd" "$remoteIp" "$password" "$remoteUser" 300 "$ssh_port"
            ret=$?

            if [ "$ret" -ne 0 ]; then
                LOG_ERROR "pkg_list:${__pkg_list[*]} remove failed."
                exit 1
            fi
        fi
    fi

    [ $mode -ne 0 ] && {
        __installed_pkgs=$tmpf
    }
}

function IS_FREE_PORT() {
    port=$1
    ip=${2-""}
    if [ -n $ip ]; then
        ifconfig | grep $ip
        if [ $? -ne 0 ]; then
            LOG_ERROR "check ip not local ip, not support IS_FREE_PORT"
            exit 1
        fi
    fi

    get_num=$(netstat -nltp | grep $port | wc -l)
    if [ $get_num -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

function GET_FREE_PORT() {
    ip=${1-""}
    start_port=${2-1000}
    end_port=${3-10000}
    if [ -n $ip ]; then
        ifconfig | grep $ip
        if [ $? -ne 0 ]; then
            LOG_ERROR "check ip not local ip, not support GET_FREE_PORT"
            exit 1
        fi
    fi
    
    range=`expr $end_port - $start_port`
    for i in seq 100; do
        rand=`expr $RANDOM % $range`
        new_port=`expr $start_port + $rand`
        check=IS_FREE_PORT new_port
        if [ $check -eq 0 ]; then
            return $new_port
        fi
    done

    return 0
}

function SLEEP_WAIT() {
    wait_time=${1-1}
    cmd=$2
    sleep_time=0

    waiteType=${wait_time: -1}
    waitesend=${wait_time:0:-1}
    case $waiteType in
    m)
        waitesend=`expr $waitesend * 60`
        ;;
    h)
        waitesend=`expr $waitesend * 3600`
        ;;
    s)
        ;;
    [0-9])
        waitesend=$wait_time
        ;;
    *)
        LOG_ERROR "only support h m s"
        ;;
    esac

    while [ $sleep_time -lt $waitesend ]; do
        sleep 1
        if [ -n "$cmd" ]; then
            if $cmd; then
                return 0
            fi
        fi
        ((sleep_time++))
    done
}

function REMOTE_REBOOT_WAIT() {
    node=${1-2}
    waittime=${2-""}

    remoteip=$[ "NODE"$node"_IPV4" ]
    remotepasswd=$[ "NODE"$node"_PASSWORD" ]
    ssh_port=$[ "NODE"$node"_SSH_PORT" ]
    remoteuser=$[ "NODE"$node"_USER" ]

    count=0

    if [[ "$waittime"x == ""x ]]; then
        if [[ "$(dmidecode -s system-product-name)" =~ "KVM" ]]; then
            waittime=300
        else
            waittime=600
        fi
    fi

    while [ $count -lt $waittime ]; do
        if ping -c 1 $remoteip; then
            if SSH_CMD "echo '' > /dev/null 2>&1" $remoteip $remotepasswd $remoteuser; then
                return 0
            else
                SLEEP_WAIT 1
                ((count++))
            fi
        else
            SLEEP_WAIT 1
            ((count++))
        fi
    done

    return 1
}

function REMOTE_REBOOT() {
    node=${1-2}
    waittime=${2-""}

    remoteip=$[ "NODE"$node"_IPV4" ]
    remotepasswd=$[ "NODE"$node"_PASSWORD" ]
    ssh_port=$[ "NODE"$node"_SSH_PORT" ]
    remoteuser=$[ "NODE"$node"_USER" ]

    if SSH_CMD "reboot" $remoteip $remotepasswd $remoteuser; then
        LOG_ERROR "do reboot fail"
        exit 1
    else
        REMOTE_REBOOT_WAIT $node $waitetime
    fi
}
