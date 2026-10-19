#!/bin/bash
set +e
# 启动sysmonitor
yum install -y sysmonitor-kmod &> /dev/null
systemctl restart rsyslog

# shellcheck disable=SC2034
{
    MONITOR_CONFIG=/etc/sysconfig/sysmonitor
    SIGNAL_CONFIG=/etc/sysmonitor/signal
    FILE_CONFIG=/etc/sysmonitor/file
    FILE_CONFIG_UVP=/etc/sysmonitor/file-uvp
    DISK_CONFIG=/etc/sysmonitor/disk
    INODE_CONFIG=/etc/sysmonitor/inode
    NETWORK_CONFIG=/etc/sysmonitor/network
    PSCNT_CONFIG=/etc/sysmonitor/pscnt
    FDCNT_CONFIG=/etc/sysmonitor/fdcnt
    CPU_CONFIG=/etc/sysmonitor/cpu
    MEMORY_CONFIG=/etc/sysmonitor/memory
    PROCESS_CONF=/etc/sysmonitor/process
    IODELAY_CONF=/etc/sysmonitor/iodelay
    sysmonitor_log=/var/log/sysmonitor.log
    sysmonitor_conf=/etc/sysconfig/sysmonitor
    sysmonitor_list=/etc/sysmonitor
    tmp_dir=$(pwd)/monitor_tmp
    
    DIR_NAME=$(dirname "$0")
    BASE_NAME=$(basename "$0")
    MESSAGES_LOG=/var/log/sysmonitor.log
    SYS_LOG=/var/log/messages
    dfx_file_path="/opt/dfx-fault-injection"
    #process monitor start
    MONITOR_DEMOE_PATH="${PROCESS_CONF}"/cron
    MONITOR_DEMOE_PROCESS=$(grep -w 'NAME' "$MONITOR_DEMOE_PATH" | sed "s/.*NAME=\(.*\).*/\1/g")
    MONITOR_LOG="${MESSAGES_LOG}"
    MEM_FD_PROCESS=hirmd
    MEM_FD_CONF=/opt/uvp/uvpHealthCheck/uvphealth.conf
    STATUSCHECK_PARAM="-s hirmd -b /usr/bin/hirmd -n hirmd -p /var/run/hirmd.pid"
    MEM_ERR_INFO="Found unknown characters in the memory limit of service ${MEM_FD_PROCESS}"
    FD_ERR_INFO="Found unknown characters in the fdsize limit of service ${MEM_FD_PROCESS}"
    #process monitor end
}


function init() {
    monitor_restart
    sysmonitor_log=$(get_sysmonitor_log)
    MESSAGES_LOG="$sysmonitor_log"
}

function oe_err {
    LOG_ERROR "$@"
    ((exec_result++))
}

function oe_log {
    LOG_INFO "$@"
}

function fn_mount_100_disk() {
    local diskname=$1
    rm -rf /home/mnt
    mkdir -p "${diskname}"
    ext_type=mkfs.ext3
    lsmod | grep ext4 && ext_type=mkfs.ext4
    dd if=/dev/zero of=/home/mnt/disk bs=1M count=100
    echo y | "${ext_type}" /home/mnt/disk
    mount /home/mnt/disk "${diskname}"
}

function monitor_restart() {
    true > "$sysmonitor_log"
    systemctl restart sysmonitor
    wait_sysmonitor_ready
}

function wait_sysmonitor_ready() {
    local i=1
    for ((i = 1; i <= 15; i++)); do
        sleep 1
        if systemctl status sysmonitor | grep running; then
            LOG_INFO "sysmonitor status ok!"
            return 0
        fi
        LOG_INFO "wait status:[${i}/15]..."
    done
    return 1
}

function fn_wait_for_monitor_log_print() {
    count=${2:-60}
    monitor_log_file=${4:-$sysmonitor_log}
    for ((i = 1; i <= count; i++)); do
        grep "$1" "${monitor_log_file}" && return 0
        oe_log "info" "[$i]wait for $1..."
        sleep 2
    done
    return 1
}

function add_daemon_custommonitor() {
    echo "MONITOR_SWITCH=\"on\"
TYPE=\"daemon\"
EXECSTART=\"/tmp/$1\"" > /etc/sysmonitor.d/"$1"
    chmod 600 /etc/sysmonitor.d/"$1"
    echo "#!/bin/bash
while true; do
    echo \"\$(date)\" daemon1 test >>/tmp/test
    echo \"\$SHELL\" >>/tmp/test
    mkdir -p /tmp/test1
    sleep 40
done" > /tmp/daemon1
    chmod 550 /tmp/"$1"
}

function add_periodic_custommonitor() {
    echo "MONITOR_SWITCH=\"on\"
TYPE=\"periodic\"
EXECSTART=\"sh /tmp/$1\"
PERIOD=\"3\"" > /etc/sysmonitor.d/"$1"
    chmod 600 /etc/sysmonitor.d/"$1"
    echo "#!/bin/bash
echo \`date\` periodic1 test >>/tmp/test" > /tmp/periodic1
    chmod 550 /tmp/"$1"
}

function del_custommonitor() {
    rm /etc/sysmonitor.d/"$1"
    rm /tmp/"$1"
}

#usage：使用stress-ng工具对内存memory加压
# input: $1: 加压比率
#        $2: 加压时间
function stress_mem() {
    local ratio=${1-90}
    local stress_time=${2-300}
    local total_mem
    total_mem=$(free -m | grep Mem | awk '{print $2}')
    local target_mem=$((total_mem * ratio / 100))
    swapoff -a && sync
    nohup stress-ng --vm 4 --vm-bytes "${target_mem}M" --vm-keep --timeout "${stress_time}s" &> /dev/null &
    SLEEP_WAIT 10
}

#usage：使用stress-ng工具对cpu加压
# input: $1: 加压比率
#        $2: 加压时间
function stress_cpu() {
    local ratio=${1-90}
    local stress_time=${2-300}
    local cpu_num
    cpu_num=$(grep -c "processor" /proc/cpuinfo)
    nohup stress-ng --cpu "${cpu_num}" -l "${ratio}" --timeout "${stress_time}" &> /dev/null &
}
function stress_cpu_with_num() {
    local cpu_core=${1:-1}
    local ratio=${2-90}
    local stress_time=${3-300}
    local cpu_num
    cpu_num=$(grep -c "processor" /proc/cpuinfo)
    nohup taskset -c "$cpu_core" stress-ng --cpu "${cpu_num}" -l "${ratio}" --timeout "${stress_time}" &> /dev/null &
}

#usage：清除环境加压
function pressure_clear() {
    pgrep stress-ng && pkill -9 stress-ng
}

function mem_prefun() {
    local memory_alarm_config_value=75
    local memory_resume_config_value=70
    cp -a ${sysmonitor_conf} ${sysmonitor_conf}.bak
    sed -i "/^MEM_MONITOR=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    sed -i "/^MEM_ALARM=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    cp -a /etc/sysmonitor/memory /etc/sysmonitor/memory.bak
    echo 3 > /proc/sys/vm/drop_caches
    sed -i "/^ALARM=/ s/=.*/=\"${memory_alarm_config_value}\"/" /etc/sysmonitor/memory
    sed -i "/^RESUME=/ s/=.*/=\"${memory_resume_config_value}\"/" /etc/sysmonitor/memory
    sed -i "/^PERIOD=/ s/=.*/=\"2\"/" /etc/sysmonitor/memory
    monitor_restart
}

function mem_postfun() {
    mv ${sysmonitor_conf}.bak ${sysmonitor_conf}
    mv /etc/sysmonitor/memory.bak /etc/sysmonitor/memory
    monitor_restart
}

function disk_prefun() {
    cp -a ${sysmonitor_conf} ${sysmonitor_conf}.bak
    cp -a ${DISK_CONFIG} ${DISK_CONFIG}.bak
    sed -i "/^DISK_MONITOR_PERIOD=/ s/=.*/=\"5\"/" ${sysmonitor_conf}
    sed -i "/^DISK_MONITOR=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    monitor_restart
}

function disk_postfun() {
    mv ${sysmonitor_conf}.bak ${sysmonitor_conf}
    mv ${DISK_CONFIG}.bak ${DISK_CONFIG}
    monitor_restart
}

function fn_clean_disk_to_zero() {
    local tmp_disk="$1"
    rm -rf "${tmp_disk}/tmpfile_*" &> /dev/null
}

function fn_clean_disk_to_resume() {
    tmp_disk=$1
    tmp_resume=$(($2 - 5))
    for ((i = 1; i <= 900000; i++)); do
        rm -r "${tmp_disk}/tmpfile_$i" > /dev/null 2>&1
        size=$(df "${tmp_disk}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
        if [ "${size}" -lt "${tmp_resume}" ]; then
            oe_log "disk size reach to RESUME ${tmp_resume}"
            df "${tmp_disk}"
            break
        fi
        temp=$((i % 100))
        if [ "$temp" = 0 ]; then
            df "${tmp_disk}"
        fi
    done
}

function fn_make_inode_alarm() {
    tmp_inode=$1
    tmp_alarm=$(($2 + 4))
    add=$3
    mkdir -p "$tmp_inode"/tmp_inode
    df -i "$tmp_inode"
    oe_log "stating ...create file:"
    sum=$(df -i "${tmp_inode}" | awk 'NR==2{print $2}')
    used=$(df -i "${tmp_inode}" | awk 'NR==2{print $3}')
    create=$((sum * tmp_alarm / 100 - used))
    # reduce create time
    for i in $(seq 1 10000 $create); do
        [ "$i" -eq $((create / 10000 * 10000)) ] && break
        [ $((i + 10000)) -gt "$create" ] && break
        eval "touch $tmp_inode/tmp_inode/tmpfile_${add}{${i}..$((i + 10000))}" &> /dev/null
    done
    eval "touch $tmp_inode/tmp_inode/tmpfile_${add}{${i}..${create}}" &> /dev/nul
    size=$(df -i "${tmp_inode}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
    echo "**************${size}***********************"
    df -i "${tmp_inode}"
}
function fn_clean_inode_to_zero() {
    tmp_inode=$1
    clean_flag=${2:-0}
    rm -rf "${tmp_inode}"/tmp_inode
    size=$(df -i "${tmp_inode}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
    echo "**************${size}***********************"
    if [ "$clean_flag" -ne 1 ]; then
        df -i "${tmp_inode}"
        umount -l "${tmp_inode}"
        rm -rf "${tmp_inode}"
    fi
}

fn_make_disk_alarm() {
    tmp_disk=$1
    tmp_alarm=$(($2 + 5))
    for i in $(seq 900000); do
        size_old=$(df "${tmp_disk}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
        echo "**************${size_old}***********************"
        dd if=/dev/zero of="${tmp_disk}"/tmpfile_"$i" oflag=direct bs=1M count=1 > /dev/null 2>&1
        size=$(df "${tmp_disk}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
        if [ "${size}" -ge "${tmp_alarm}" ]; then
            oe_log "info" "disk size reach to ALARM ${tmp_alarm}"
            df "${tmp_disk}"
            break
        fi
        temp=$((i % 100))
        if [ "$temp" = 0 ]; then
            df "${tmp_disk}"
        fi
    done
}

fn_clean_disk_to_zero() {
    tmp_disk=$1
    rm -r "${tmp_disk}"/tmpfile_* > /dev/null 2>&1
}

function make_dir_mount() {
    ext_type=mkfs.ext3
    lsmod | grep ext4 && ext_type=mkfs.ext4

    rm -rf /home/mnt
    mkdir -p /home/mnt/mpoint
    dd if=/dev/zero of=/home/mnt/disk bs=1M count=100
    echo y | ${ext_type} /home/mnt/disk
    mount /home/mnt/disk /home/mnt/mpoint
    df -h
}

function recover_dir_mount() {
    umount -l /home/mnt/mpoint
    rm -rf /home/mnt/mpoint
    rm -rf /home/mnt
}

function zombie_pre() {
    true > "${sysmonitor_log}"
    cp -a ${sysmonitor_conf} ${sysmonitor_conf}.bak
    sed -i "/^ZOMBIE_MONITOR=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    sed -i "/^ZOMBIE_ALARM=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    monitor_restart
}

function zombie_post() {
    mv ${sysmonitor_conf}.bak ${sysmonitor_conf}
    monitor_restart
}

function file_monitor_prefun() {
    cp -a ${sysmonitor_conf} ${sysmonitor_conf}.bak
    sed -i "/^FILE_MONITOR=/ s/=.*/=\"on\"/" ${sysmonitor_conf}
    monitor_restart
}

function file_monitor_postfun() {
    mv ${sysmonitor_conf}.bak ${sysmonitor_conf}
    monitor_restart
}

function wait_log() {
    local count=60
    local logfile=${2-${sysmonitor_log}}
    for ((i = 1; i <= count; i++)); do
        oe_log "[$i] wait in [${logfile}]..."
        if echo "$1" | grep -E "[.*+]"; then
            grep -E "$1" "${logfile}" && return 0
        else
            grep "$1" "${logfile}" && return 0
        fi
        sleep 2
    done
    return 1
}

function wait_monitor_log() {
    wait_log "$1" "${sysmonitor_log}"
    return $?
}

function multi_grep_print() {
    local args=""
    while [ $# -ge 2 ]; do
        args="${args}.*$1"
        shift
    done
    echo "$args"
}

function multi_grep_wait_log() {
    local count=60
    local args=""
    args=$(multi_grep_print "$@")
    local file=$#
    file="${!file}"
    oe_log "[multi grep wait] in ==$file=="
    wait_log "$args" "$file"
    return $?
}
