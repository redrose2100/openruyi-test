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
#@Date      	:   2020-04-08 16:13:40
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Encapsulate ssh, user t directly, and execute remote commands
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Base64 payload + temp file, identical in shape to ssh_cmd.py wrap_cmd().
# Keep the two layers byte-compatible: same SUDO_TMP_PREFIX, same template.
MUGEN_SUDO_TMP_PREFIX="/tmp/.mgn_"
MUGEN_SUDO_PROMPT="MUGEN_SUDO_PWD:"

function _mugen_sudo_wrap() {
    local _cmd="$1"
    local _mode="$2"

    # root / none short circuit, no wrapping at all (zero regression)
    if [ "${_mode}"x = "root"x ] || [ "${_mode}"x = "none"x ] || [ -z "${_mode}" ]; then
        printf '%s' "${_cmd}"
        return 0
    fi

    local _payload
    _payload=$(printf '%s' "${_cmd}" | base64 -w 0)
    local _sudo_call
    if [ "${_mode}"x = "nopasswd"x ]; then
        _sudo_call="sudo -n -H sh \$T"
    else
        _sudo_call="sudo -S -p '${MUGEN_SUDO_PROMPT}' -H sh \$T"
    fi

    printf '%s' "umask 077; T=\$(mktemp ${MUGEN_SUDO_TMP_PREFIX}XXXXXX 2>/dev/null) || T=${MUGEN_SUDO_TMP_PREFIX}\$\$; printf '%s' '${_payload}' | base64 -d > \$T; ${_sudo_call}; r=\$?; rm -f \$T; exit \$r"
}

# Privileged path: wraps the command and feeds BOTH the login password and the
# sudo password through expect. Kept in its own function so the root path below
# stays byte-identical to the legacy implementation.
function _mugen_ssh_sudo() {
    local _raw="$1"
    local _ip="$2"
    local _pwd="$3"
    local _user="$4"
    local _timeout="$5"
    local _port="$6"
    local _mode="$7"
    local _sudopwd="$8"
    local _tty="$9"

    local _wrapped _esc
    _wrapped=$(_mugen_sudo_wrap "${_raw}" "${_mode}")
    # '$' must survive the unquoted heredoc as a literal dollar for the remote sh
    _esc=${_wrapped//\$/\\\$}

    local _tty_opt=""
    [ "${_tty}"x = "true"x ] && _tty_opt="-tt"

    local _e_time="${_timeout}"
    local _last_world
    _last_world=$(echo "${_raw}" | awk '{print $NF}')
    [ "${_last_world}"x = "&"x ] && _e_time=-1

    expect <<-EOF
    set timeout ${_e_time}
    set pw_tries 0
    set sudo_tries 0
    spawn ssh ${_tty_opt} -o "ConnectTimeout=${_timeout}" -p ${_port} ${_user}@${_ip} "${_esc}"
    expect {
        "Are you sure you want to continue connecting*"
        {
            send "yes\r"
            exp_continue
        }
        "*\[P|p]assword:"
        {
            incr pw_tries
            if {\$pw_tries > 2} {
                send_user "authentication failed for ${_user}@${_ip}\n"
                exit 5
            }
            send "${_pwd}\r"
            exp_continue
        }
        "${MUGEN_SUDO_PROMPT}"
        {
            incr sudo_tries
            if {\$sudo_tries > 2} {
                send_user "sudo password rejected on ${_ip}\n"
                exit 5
            }
            send "${_sudopwd}\r"
            exp_continue
        }
        eof
        {
            catch wait result
            exit [lindex \$result 3]
        }
        timeout
        {
            send_user "connection to ${_ip} timed out\n"
            exit 91
        }
    }
EOF
    return $?
}

function sshcmd() {
    cmd=$1
    remoteip=$2
    remotepasswd=${3}
    remoteuser=${4}
    timeout=${5}
    connport=${6}
    sudo_mode=${7}
    sudo_pwd=${8}
    use_tty=${9}

    test "$cmd"x = ""x && LOG_ERROR "Lack of execute command." && exit 1
    # base64 payload must be built from the UNESCAPED command: escaping turns
    # '$' into '\$' which sh inside the temp script would read literally.
    raw_cmd="$cmd"
    cmd=${cmd//\$/\\\$}

    test "$remoteip"x = ""x && LOG_ERROR "Missing ip."
    test "$(echo ${remoteip} | awk -F"." '{if ($1!=0 && $NF!=0) split ($0,IPNUM,".")} END { for (k in IPNUM) if (IPNUM[k]==0) print IPNUM[k]; else if (IPNUM[k]!=0 && IPNUM[k]!~/[a-z|A-Z]/ && length(IPNUM[k])<=3 && IPNUM[k]<=255 && IPNUM[k]!~/^0/) print IPNUM[k]}' | wc -l)" -ne 4 && LOG_ERROR "the remote ip is Incorrect." && exit 1
    if ping -c 1 ${remoteip} | grep "100% packet loss"; then
        LOG_ERROR "connection to $remoteip failed."
        exit 101
    fi

    test "$remoteuser"x = "root"x && LOG_WARN "the remote user uses the default configuration."

    test "$remotepasswd"x = "openEuler12#$"x && LOG_WARN "the remote password uses the default configuration."

    test "$timeout"x = "15"x && LOG_WARN "the timeout uses the default configuration."

    test "$connport"x = "22"x && LOG_WARN "the connect port using the default configuration"

    cmd_last_world=$(echo ${cmd} | awk '{print $NF}')

    e_time=${timeout}

    test "$cmd_last_world"x == "&"x && {
        timeout=0
        e_time=-1
    }

    # Non-root login: escalate through sudo. The whole privileged path lives in
    # _mugen_ssh_sudo(); everything below this guard is the untouched legacy
    # expect block, so root deployments behave exactly as before.
    if [ "${sudo_mode}"x != ""x ] && [ "${sudo_mode}"x != "root"x ] && [ "${sudo_mode}"x != "none"x ]; then
        _mugen_ssh_sudo "${raw_cmd}" "${remoteip}" "${remotepasswd}" "${remoteuser}" "${timeout}" "${connport}" "${sudo_mode}" "${sudo_pwd}" "${use_tty}"
        exit $?
    fi

    expect <<-EOF

    set timeout ${e_time}
         
    spawn ssh -o "ConnectTimeout=${timeout}"  -p ${connport} ${remoteuser}@${remoteip} "$cmd"

        expect {
            "Are you sure you want to continue connecting*"
            {
                send "yes\r"
                expect "*\[P|p]assword:"
                send "${remotepasswd}\r"
            }
            "*\[P|p]assword:"
            {
                send "${remotepasswd}\r"
            }
            timeout 
            {
                send_user "connection to $remoteip timed out: \$expect_out(buffer)\n"
                exit 101
        	}
            eof 
            {
                catch wait result
                exit [lindex \$result 3] 
            }
        }
        expect {
            eof {
                catch wait result
                exit [lindex \$result 3] 
            }
            "\[P|p]assword:" 
            {
                send_user "invalid password or account again.\$expect_out(buffer)\n"
                send "${remotepasswd}\r"
            }
            timeout 
            {
                send_user "connection to $remoteip timed out: \$expect_out(buffer)\n"
                exit 101
            }
        }
    }
EOF
    exit $?
}

usage() {
    printf "Usage: sshcmd.sh -c \"command\" -i \"remote machinet ip\" [-u login_user] [-p login_password] [-o port] [-t timeout]\n"
    printf "       [-s sudo_mode: root|none|nopasswd|password] [-w sudo_password] [-T]\n"
}

while getopts "c:i:p:u:t:o:s:w:Th" OPTIONS; do
    case $OPTIONS in
    c) cmd="$OPTARG" ;;
    i) remoteip="$OPTARG" ;;
    u) remoteuser="$OPTARG" ;;
    p) remotepasswd="$OPTARG" ;;
    t) timeout="$OPTARG" ;;
    o) connport="$OPTARG" ;;
    s) sudo_mode="$OPTARG" ;;
    w) sudo_pwd="$OPTARG" ;;
    T) use_tty="true" ;;
    \?)
        printf "ERROR - Invalid parameter" >&2
        usage
        exit 1
        ;;
    *)
        printf "ERROR - Invalid parameter" >&2
        usage
        exit 1
        ;;
    esac
done

if [ "$cmd"x = ""x ] || [ "$remoteip"x = ""x ]; then
    usage
    exit 1
fi

sshcmd "$cmd" "$remoteip" "${remotepasswd-openEuler12#$}" "${remoteuser-root}" "${timeout-300}" "${connport-22}" "${sudo_mode-}" "${sudo_pwd-}" "${use_tty-false}"

exit $?
