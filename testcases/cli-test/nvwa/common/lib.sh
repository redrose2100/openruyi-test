#!/usr/bin/bash
  
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yuanlulu
# @Contact   :   127248816@qq.com
# @Date      :   2023/10/09
# @License   :   Mulan PSL v2
# @Desc      :   nvwa common function
# #############################################
# shellcheck disable=SC2002,SC2009,SC2148,SC2162,SC2181,SC1091,SC2164,SC2010,SC2034,SC2103,SC2086,SC2126,SC2010,SC2188,SC2162
set +e
source "${OET_PATH}"/libs/locallibs/common_lib.sh
# grub.cfg
#GRUB_PATH=$(find /boot -name grub.cfg)
if ls /sys/firmware/efi; then
  GRUB_PATH=$(find /boot/efi -name grub.cfg)
else
  GRUB_PATH=$(find /boot/grub2 -name grub.cfg)
fi

#baseline
BASELINE_KERNEL_VERSION="$(uname -r)"
BASELINE_INITFS_PATH="/boot/initramfs-$BASELINE_KERNEL_VERSION.img"
BASELINE_VMLINUZ_PATH="/boot/vmlinuz-$BASELINE_KERNEL_VERSION"

# cmdline list
current_cmdline=$(SSH_CMD "cat /proc/cmdline" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -1 | sed 's/\r//')
QKEXEC="quickkexec"
CPUPARKMEM="cpuparkmem"
PINM="pinmemory"
TEST_SERVICE="./common/test_nvwa.c"
TEST_SERVICE_CONF="./common/test_nvwa.service"
TEST_SERVICE_SH="./common/test_nvwa.sh"
SYSTEMD_PATH="/etc/systemd/system"
NVWA_PATH="/etc/nvwa"

function deploy_nvwa() {
    #SSH_CMD "rpm -qa | grep nvwa || yum install -y nvwa" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    DNF_INSTALL "nvwa" 2
    SSH_CMD "systemctl start nvwa; systemctl enable nvwa" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #disable selinux
    SSH_CMD "getenforce | grep Disabled" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    if [ $? -ne 0 ]; then
        SSH_CMD "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        SSH_CMD "reboot &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        #REMOTE_REBOOT_WAIT 2 15
        wait_ssh "${NODE2_IPV4}" "300"
	CHECK_RESULT $?
    fi
}

function check_cmdline_apply() {
    local tmp_cmd_list=${1}
    if [[ $tmp_cmd_list =~ $QKEXEC ]]; then
        SSH_CMD "grep 'Quick kexec' /proc/iomem" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        CHECK_RESULT $?
    fi
    if [[ $tmp_cmd_list =~ $CPUPARKMEM ]]; then
        SSH_CMD "dmesg | grep  'cpu-park'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        CHECK_RESULT $?
    fi
    if [[ $tmp_cmd_list =~ $PINM ]]; then
        SSH_CMD "grep 'Pin' /proc/iomem" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        CHECK_RESULT $?
    fi
    rm -rf /tmp/dmesg
}

function deploy_nvwwa_with_conf() {
    SSH_CMD "cp $GRUB_PATH $GRUB_PATH.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "grubby --update-kernel=ALL --args='quickkexec=128M max_pin_pid_num=10 redirect_space_size=2M pinmemory=100M@0x40000000 cpuparkmem=0x13bfe0000'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "reboot &" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #REMOTE_REBOOT_WAIT 2 15
    wait_ssh "${NODE2_IPV4}" "300"
    CHECK_RESULT $?

    check_cmdline_apply "quickkexec pinmemory cpuparkmem"
    SSH_CMD "ls /etc/nvwa/nvwa-restore.yaml.bak || cp /etc/nvwa/nvwa-restore.yaml /etc/nvwa/nvwa-restore.yaml.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "sed -i 's/enable_quick_kexec\: false/enable_quick_kexec\: true/g' /etc/nvwa/nvwa-restore.yaml" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "sed -i 's/enable_pin_memory\: false/enable_pin_memory\: true/g' /etc/nvwa/nvwa-restore.yaml" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function prepare_redis() {
    rpm -qa | grep redis || yum install -y redis
    SSH_CMD "rpm -qa | grep redis || yum install -y redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl stop firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl disable firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function deploy_redis() {
    local num redis_process port
    redis_process=${1-1}
    prepare_redis
    SSH_CMD "sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    for num in $(seq $redis_process); do
        port=$((6379 + $num - 1))
        SSH_CMD "mkdir -p /root/redis_conf/$port" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        SSH_CMD "cp /etc/redis.conf /root/redis_conf/$port" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
        SSH_CMD "sed -i "s/6379/$port/g" /root/redis_conf/$port/redis.conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    done
}

function start_redis(){
    local num redis_process port
    redis_process=${1-1}

    for num in $(seq $redis_process);do
        port=$((6379+$num-1))
        SSH_CMD "/usr/bin/redis-server /root/redis_conf/$port/redis.conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    done
}

function deploy_redis_service() {
    prepare_redis
    SSH_SCP "./common/redis.service" "${NODE2_USER}"@"${NODE2_IPV4}":/etc/systemd/system/ "${NODE2_PASSWORD}"
    SSH_CMD "systemctl enable redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl start redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function get_process_pid() {
    local pids process_name
    process_name=${1}
    pid_num=$(SSH_CMD "ps aux | grep $process_name | grep -v grep | wc -l" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -1 | sed 's/\r//')
    pids=$(SSH_CMD "ps aux | grep $process_name | grep -v grep | awk '{print \$2}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"| tail -$pid_num | sed 's/\r//')
    echo $pids
}
function modify_nvwa_restore_by_pid() {
    local pids=${1}
    SSH_CMD "ls /etc/nvwa/nvwa-restore.yaml.bak || cp /etc/nvwa/nvwa-restore.yaml /etc/nvwa/nvwa-restore.yaml.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    for pid in ${pids[*]}; do
        echo $pid
        SSH_CMD "sed '/pids:/ a\  - $pid' -i /etc/nvwa/nvwa-restore.yaml" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    done
}

function clear_nvwa_restore_pid() {
    local pids=${1}
    for pid in ${pids[*]}; do
        SSH_CMD "kill -9 $pid" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    done
    SSH_CMD "rm -rf /root/redis_conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function nvwa_procee_confirm() {
    local pids=${1}
    for pid in ${pids[*]}; do
        SSH_CMD "ps aux | grep -v grep | awk '{print \$2}'| grep $pid" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" || return 1
    done
    return 0
}

function restore_nvwa_restore() {
    SSH_CMD "mv /etc/nvwa/nvwa-restore.yaml.bak /etc/nvwa/nvwa-restore.yaml" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function clean_nvwa() {
    SSH_CMD "systemctl disable nvwa;systemctl stop nvwa" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "cp /etc/selinux/config  /etc/selinux/config.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "sed -i 's/SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "touch /.autorelabel" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #REMOTE_REBOOT_WAIT 2 60
    wait_ssh "${NODE2_IPV4}" "300"
    CHECK_RESULT $?
    SSH_CMD "mv /etc/selinux/config.bak /etc/selinux/config" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "mv $GRUB_PATH.bak $GRUB_PATH" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #REMOTE_REBOOT_WAIT 2 60
    wait_ssh "${NODE2_IPV4}" "300"
    CHECK_RESULT $?
    DNF_REMOVE "$@" 2
}

function clean_redis() {
    SSH_CMD "rm -rf /root/redis_conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    yum remove -y redis
    SSH_CMD "systemctl enable firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl start firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "yum remove -y redis" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function wait_ssh() {
    local node_ipv4="$1"
    local time="$2"
    if [[ -z "$node_ipv4" ]]; then
	LOG_ERROR "Usage: wait_rv_ssh <ipv4>"
    	return 1
    fi
    DNF_INSTALL "nmap-ncat"
    LOG_INFO "Waiting for node '${node_ipv4}' to reboot and SSH to become available..."
    if ! timeout $time bash -c "
        while ! nc -zvnw 3 '${node_ipv4}' 22 2>/dev/null; do
	   sleep 30
        done
    "; then
        LOG_ERROR "Node ${node_ipv4} did not come back online within ${time} seconds after reboot"
        exit 1
    fi
    LOG_INFO "Node ${node_ipv4} is back online."
}

