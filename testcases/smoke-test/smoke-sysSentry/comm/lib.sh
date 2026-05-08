#!/usr/bin/bash
# shellcheck disable=SC1091,SC2034,SC2154,SC2207
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   yangna 
# @Date      :   2025/12/12
# ##################################


source "$OET_PATH/libs/locallibs/common_lib.sh"

TMP_DIR=/root/sysSentry_script
task_log_path=/var/log/sysSentry
run_alarm="/var/run/xalarm/alarm"
run_report="/var/run/xalarm/report"
xalarm_run_dir="/var/run/xalarm"
version=$(rpm -qi sysSentry 2>/dev/null | grep -i "release" | awk '{print $3}' | cut -d'.' -f1)
if [ -n "$version" ] && [ "$version" -gt 27 ]; then
    ra_path="$OET_PATH/testcases/smoke-test/smoke-sysSentry/RA"
else
    ra_path="$OET_PATH/testcases/smoke-test/smoke-sysSentry/RA_V27"
fi
mkdir -p "${TMP_DIR}"

function pre_env(){
    local node_num="$1"

    DNF_INSTALL "sysSentry" 1
    DNF_INSTALL "sysSentry" 2
    [ -n "${node_num}" ] && DNF_INSTALL "sysSentry" 3
    start_sentry

    SSH_CMD "
    yum -y install sentry_msg_monitor
    systemctl start xalarmd
    systemctl start sysSentry
    modprobe sentry_msg_helper
    modprobe sentry_reporter
    sleep 5
    modprobe sentry_urma_comm
    modprobe odf
    modprobe cis
    sleep 5
    modprobe sentry_remote_reporter
    sentryctl start sentry_msg_monitor
    sleep 5
    lsmod | grep sentry
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

   [ -n "${node_num}" ] && SSH_CMD "
    yum -y install sentry_msg_monitor
    systemctl start xalarmd
    systemctl start sysSentry
    modprobe sentry_msg_helper
    modprobe sentry_reporter
    sleep 5
    modprobe sentry_urma_comm
    modprobe odf
    modprobe cis
    sleep 5
    modprobe sentry_remote_reporter
    sentryctl start sentry_msg_monitor
    sleep 5
    lsmod | grep sentry
    " "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"

    get_eid

}
function pre_oom_env(){
    yum -y install sentry_msg_monitor
    modprobe sentry_msg_helper
    modprobe sentry_reporter
    systemctl start xalarmd
    systemctl start sysSentry
    sleep 5 
    sentryctl list | grep sentry_msg_monitor

}

function pre_xalarm_env(){
    DNF_INSTALL "sysSentry" 1
    yum -y remove libxalarm pyxalarm sentry_msg_monitor sysSentry
    yum -y install sentry_msg_monitor
    systemctl start xalarmd
    systemctl start sysSentry
    sleep 5
    sentryctl list | grep sentry_msg_monitor
}

function start_sentry(){
    yum -y install sentry_msg_monitor
    systemctl start xalarmd
    systemctl start sysSentry
    modprobe sentry_msg_helper
    modprobe sentry_reporter
    sleep 5
    modprobe sentry_urma_comm
    modprobe odf
    modprobe cis
    sleep 5
    modprobe sentry_remote_reporter
    sentryctl start sentry_msg_monitor
    sleep 5
    lsmod |grep sentry
}

function get_eid(){
    node1_eid1=$(urma_admin show | awk '/udma2/ && /eid0/ {print $5}')
    node1_eid2=$(urma_admin show | awk '/udma5/ && /eid0/ {print $5}')

    node2_eid1=$(SSH_CMD "urma_admin show | awk '/udma2/ && /eid0/ {print \$5}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | grep -oE '([0-9a-fA-F]{4}:){7}[0-9a-fA-F]{4}')
    node2_eid2=$(SSH_CMD "urma_admin show | awk '/udma5/ && /eid0/ {print \$5}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | grep -oE '([0-9a-fA-F]{4}:){7}[0-9a-fA-F]{4}')

    node3_eid1=$(SSH_CMD "urma_admin show | awk '/udma2/ && /eid0/ {print \$5}'" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}" | grep -oE '([0-9a-fA-F]{4}:){7}[0-9a-fA-F]{4}')
    node3_eid2=$(SSH_CMD "urma_admin show | awk '/udma5/ && /eid0/ {print \$5}'" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}" | grep -oE '([0-9a-fA-F]{4}:){7}[0-9a-fA-F]{4}')
    
    # node1_cna=1
    # node2_cna=2
    node1_cna=$(( $(tr -d '[:space:]' < /sys/devices/ub_bus_controller0/00001/primary_cna) ))
    raw_output=$(SSH_CMD "cat /sys/devices/ub_bus_controller0/00001/primary_cna 2>/dev/null" \
        "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}")
        
    hex_value=$(echo "$raw_output" | tr -d '[:space:]' | grep -oE '0x[0-9A-Fa-f]+')
    node2_cna=$(( hex_value ))
    node3_cna=3
    test_jetty_id=$((RANDOM % 1021 + 3))

}
function gcc_ra(){
    local ra_type="$1"
    [ -n "${ra_type}" ] && ra_type="_$ra_type"
    yum -y install sentry_msg_monitor libxalarm-devel gcc
    gcc "${ra_path}"/RA"${ra_type}".c -Wall -o3 -lxalarm -o "${ra_path}"/RA"${ra_type}"
    chmod 777 "${ra_path}/RA${ra_type}"



}
function start_RA(){
    local ra_type="${1}"
    local ra_pare="${2:-}"
    local delay_time="${3:-}"
    case $ra_type in 
        panic | kernel_reboot)
            [ -f "${ra_path}"/RA_reboot ] || gcc_ra reboot
            stdbuf -oL "${ra_path}/RA_reboot" "${ra_pare}" "${delay_time}" > "${TMP_DIR}/RA.log" 2>&1 & 
            ;;
        oom)
            [ -f "${ra_path}"/RA_oom ] || gcc_ra oom
            stdbuf -oL "${ra_path}/RA_${ra_type}" > "${TMP_DIR}/RA.log" 2>&1 &
            ;;
        *)
            [ -f "${ra_path}"/RA_"${ra_type}" ] || gcc_ra "${ra_type}"
            stdbuf -oL "${ra_path}/RA_${ra_type}" > "${TMP_DIR}/RA_${ra_type}.log" 2>&1 &
            ;;

    esac
    return $?
}

function check_RA_xalarmd(){
    local ra_log="${1-RA_xalarmd.log}"
    SLEEP_WAIT 30 "grep -aw 'alarmid:1003' ${TMP_DIR}/${ra_log} | grep -w 'msg:hello'" 2
    CHECK_RESULT $? 0 0
}
function check_RA_plugin(){
    local ra_log="${1-RA_plugin.log}"
    SLEEP_WAIT 30 "grep -aw 'alarmid:1004' ${TMP_DIR}/${ra_log} | grep -w 'msg:ACK OK'" 2    
    CHECK_RESULT $? 0 0
}
function clean_sysSentry_message(){
    echo > /var/log/sysSentry/xalarm.log
    echo > /var/log/sysSentry/sentry_msg_monitor.log
}

function check_oom_dmesg(){
    local sync_value="${1}"
    local reason_value="${2}"
    SLEEP_WAIT 30 "dmesg | grep -aw \"got lowmem message\" | grep -a \"sync=${sync_value} reason=${reason_value}\"" 2
}
function check_RA_oom(){
    local sync_value="${1}"
    local reason_value="${2}"
    for ((check_ra_oom_loop=0; check_ra_oom_loop<5; check_ra_oom_loop++)); do
        grep -aw "\[alarmid:1005\]" ${TMP_DIR}/RA.log | grep -F "sync:${sync_value},timeout:30000,reason:${reason_value}" && break
        sleep 2
    done
    [ "${check_ra_oom_loop}" -lt 5 ] || return 1
    tmp_nid_info=$(grep -aw "\[alarmid:1005\]" ${TMP_DIR}/RA.log | tail -1 | grep "\[msg:.*\]" | awk -F'{' '{print $2}' | awk -F'}' '{print $1}' | awk -F']' '{print $1}')
    echo "$tmp_nid_info"
    check_oom_nid_info "${tmp_nid_info}"
    CHECK_RESULT $? 0 0
}
function check_alarmd(){
    local tmp_alarm_id="${1}"
    local tmp_alarm_msg_len="${2}"
    local is_reply="${3}"
    local tmp_reply_msg_len="${4}"
    grep -aw "Broadcast msg success" ${task_log_path}/xalarm.log | grep "alarm msg is alarm_id: ${tmp_alarm_id}, alarm_level: MINOR_ALM, alarm_type: ALARM_TYPE_OCCUR"
    CHECK_RESULT $? 0 0

    grep "alarm_id: ${tmp_alarm_id}" ${task_log_path}/xalarm.log
    CHECK_RESULT $? 0 0

}
function check_oom_sentry_msg_monitor(){
    local sync_value="${1}"
    local reason_value="${2}"
    local is_reply="${3-true}"
    grep -aw 'Send msg success:' ${task_log_path}/sentry_msg_monitor.log | grep -w "alarm_type: 1005" 
    CHECK_RESULT $? 0 0
    tmp_nid_info=$(grep -aw "alarm_type: 1005" ${task_log_path}/sentry_msg_monitor.log | tail -1 | awk -F'str:' '{print $2}' | awk -F'{' '{print $2}' | awk -F'}' '{print $1}' | awk -F']' '{print $1}')
    check_oom_nid_info "${tmp_nid_info}"
    CHECK_RESULT $? 0 0
}

function check_oom_nid_info(){
    local tmp_nid_info="${1}"
    # nr_nid=$(echo "$tmp_nid_info" | grep -oP '(?<=nr_nid:)\d+')
    # tmp_nid_str=$(echo "$tmp_nid_info" | grep -oP '(?<=nid:\[)[^\]]+(?=)')
    nid_str=($(echo "${tmp_nid_str[@]}" | tr ',' ' '))
    echo "${nid_str[@]:0:$((nr_nid))}" | grep -v '\-1'
    CHECK_RESULT $? 0 0
    echo "${nid_str[@]:$nr_nid:$((${#nid_str[@]} - 1))}" | xargs -n 1 | grep -c '\-1' | grep "$((${#nid_str[@]} - nr_nid))"
    CHECK_RESULT $? 0 0
}
function check_log(){
    local reply_type="${1}"
    local log_type="${2}"
    local alarm_value="${3}"
    local ack_value="${4}"
    local alarm_count
    local log_file
    local grep_alarm
    local grep_ack

    case "$log_type" in
        "RA")
            log_file="${TMP_DIR}/RA.log"
            grep_alarm="\[alarmid:${alarm_value}\]"
            ;;
        "alarmd")
            log_file="${task_log_path}/xalarm.log"
            grep_alarm="alarm_id: ${alarm_value},"
            grep_ack="alarm_id: ${ack_value}"
            ;;
        "monitor")
            log_file="${task_log_path}/sentry_msg_monitor.log"
            grep_alarm="alarm_type: ${alarm_value}"
            grep_ack="alarm_type: ${ack_value}"
            ;;
    esac

    timeout=$([ "$reply_type" -eq 2 ] && echo 100 || echo 50)
    sleep "$timeout"
    cat "$log_file"
    alarm_count=$(grep -ac "$grep_alarm" "$log_file")
    send_ack=$(grep -ac "$grep_ack" "$log_file")

    test "$alarm_count" -ge 1
    CHECK_RESULT $? 0 0

    if [ "$log_type" != "RA" ] && [ "$reply_type" = "0" ]; then
        test "$send_ack" -ge 1
        CHECK_RESULT $? 0 0
    fi
}
