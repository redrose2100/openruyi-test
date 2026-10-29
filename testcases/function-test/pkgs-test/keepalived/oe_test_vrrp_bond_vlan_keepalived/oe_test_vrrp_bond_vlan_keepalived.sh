#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2021/02/04
# @License   :   Mulan PSL v2
# @Desc      :   Instance 20 vrrps to 20 VLAN subnets of bond, enable use vmac
# #############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    # firewalld 只在本次运行期间临时关闭，post_test 会恢复其原始 active 状态；
    # selinux 同理，记录原模式后按原值写回，避免把 NODE1 长期留在 Permissive。
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    ORIG_SELINUX_MODE=$(getenforce 2>/dev/null)
    command -v firewalld && systemctl stop firewalld
    getenforce | grep Enforcing && setenforce 0
    DNF_INSTALL "keepalived vconfig net-tools jq"
    # 本用例要把两块网卡做成 bond 的 slave，并且会对它们执行 nmcli up（改链路状态），
    # 一旦 TEST_NIC 只返回一块、$net_card3 为空，nmcli 就会把空网卡名当参数，
    # 更危险的是可能退化成对管理网卡做 enslave。因此这里必须显式校验网卡数量。
    net_cards=$(TEST_NIC 1)
    net_card2=$(echo "$net_cards" | awk -F ' ' '{print $1}')
    net_card3=$(echo "$net_cards" | awk -F ' ' '{print $2}')
    if [[ -z "$net_card2" || -z "$net_card3" ]]; then
        LOG_WARN "At least two extra UP network interfaces outside the management NIC are required, skip this testcase."
        exit 255
    fi
    mtu1=$(ip -j link show "$net_card2" 2>/dev/null | jq -r '.[0].mtu // 1500')
    mtu2=$(ip -j link show "$net_card3" 2>/dev/null | jq -r '.[0].mtu // 1500')
    bond_mtu=$((mtu1 < mtu2 ? mtu1 : mtu2))
    [[ -z "$bond_mtu" || "$bond_mtu" -lt 68 ]] && { echo "mtu error"; exit 1; }
    nmcli connection add con-name bond0 ifname bond0 type bond bond.options "mode=active-backup,miimon=100,updelay=200,downdelay=200"
    nmcli connection add con-name slave-38 ifname "${net_card2}" type ethernet master bond0 slave-type bond
    nmcli connection add con-name slave-39 ifname "${net_card3}" type ethernet master bond0 slave-type bond
    nmcli connection modify bond0 ipv4.method manual connection.autoconnect yes ipv4.addresses 20.20.20.20/24 ipv4.dns 8.8.8.8 ipv4.gateway 20.20.20.1
    nmcli connection modify bond0 802-3-ethernet.mtu "$bond_mtu"
    nmcli connection modify slave-38 802-3-ethernet.mtu "$bond_mtu"
    nmcli connection modify slave-39 802-3-ethernet.mtu "$bond_mtu"
    nmcli connection up bond0
    nmcli connection up slave-38
    nmcli connection up slave-39
    modprobe bonding
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    for ((i = 10; i < 30; i++)); do
        vconfig add bond0 "${i}"
    done
    for ((i = 10; i < 30; i++)); do
        ifconfig bond0."${i}" up
        CHECK_RESULT $?
    done
    echo "! Configuration File for keepalived
global_defs {
   notification_email {
    root@localhost
   }
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id n1
     vrrp_mcast_group4 224.1.101.18
}" >/etc/keepalived/keepalived.conf
    for ((NUM = 10; NUM < 30; NUM++)); do
        echo "vrrp_instance 4${NUM} {
    state MASTER
    use_vmac vrrp4.${NUM}.1
    interface bond0.${NUM}
    virtual_router_id 1
    priority 115
    advert_int 1
    preempt_delay 60
    authentication {
        auth_type PASS
        auth_pass a3dswd3410
    }
    virtual_ipaddress {
        192.168.111.${NUM}/24
    }
    mcast_src_ip 192.168.111.${NUM}
}" >>/etc/keepalived/keepalived.conf
    done
    systemctl start keepalived
    CHECK_RESULT $?
    SLEEP_WAIT 10
    test "$(ip a | grep vrrp4 | grep -c 192)" -eq 20
    CHECK_RESULT $?
    nmcli connection down bond0
    CHECK_RESULT $?
    SLEEP_WAIT 3
    test "$(ip a | grep vrrp4 | grep -c 192)" -eq 0
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # post_test 由 trap 保证执行，pre_test 可能在任何一步就退出，
    # 因此这里的删除动作全部加 2>/dev/null 兜底，保证幂等且不因“连接不存在”中断后续恢复。
    nmcli connection del slave-38 2>/dev/null
    nmcli connection del slave-39 2>/dev/null
    nmcli connection del bond0 2>/dev/null
    # 被 enslave 的网卡从 bond 摘除后 DNF_REMOVE 才能正常清理网络配置，
    # 这里按原网卡名恢复自动连接，避免 NODE1 上出现“UP 但无连接”的悬空状态。
    [ -n "${net_card2}" ] && nmcli connection up "${net_card2}" 2>/dev/null || true
    [ -n "${net_card3}" ] && nmcli connection up "${net_card3}" 2>/dev/null || true
    DNF_REMOVE 1 "keepalived vconfig net-tools"
    rm -rf /etc/keepalived/
    # 按准备阶段记录的原值写回 selinux，不用无条件 setenforce 1
    case "${ORIG_SELINUX_MODE}" in
    Enforcing) setenforce 1 ;;
    Permissive) setenforce 0 ;;
    "") LOG_WARN "Original selinux mode unknown, skip selinux restore." ;;
    *) LOG_WARN "selinux mode ${ORIG_SELINUX_MODE} cannot be restored by setenforce, skip." ;;
    esac
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld || LOG_WARN "Failed to restart firewalld to its original state."
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

