#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   guochenyang
#@Contact   	:   377012421@qq.com
#@Date          :   2020-07-02 11:00:43
#@License   	:   Mulan PSL v2
#@Desc          :   verification ipvsadm‘s DR_rr model
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function RANDOM_IP() {
    while true; do
        random_ip=$(ip -4 -o addr show dev $(TEST_NIC 1) | head -n 1 | awk '{print $4}' | cut -d/ -f1 | cut -d. -f1-3).$(shuf -e $(seq 1 254) | head -n 1)
        ping -c 3 "${random_ip}" &>/dev/null || {
            printf "%s" "$random_ip"
            break
        }
    done
}

function build_env() {
    if grep cloudroot /etc/passwd;then
        LOG_INFO "Network support is unavailable in the CloudPods environment."
        exit 255
    fi
    ipvs_vip=$(RANDOM_IP)
    ipvs_ip1=$(RANDOM_IP)
    ipvs_ip2=$(RANDOM_IP)
    ipvs_ip3=$(RANDOM_IP)
    ipvs_ip4=$(RANDOM_IP)
    eth_use1=$(TEST_NIC 1 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
    eth_use2=$(TEST_NIC 2 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
    eth_use3=$(TEST_NIC 3 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
    eth_use4=$(TEST_NIC 4 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
    ip addr add "$ipvs_ip1"/24 dev "${eth_use1}"
    P_SSH_CMD --node 2 --cmd "ip addr add $ipvs_ip2/24 dev ${eth_use2}"
    P_SSH_CMD --node 3 --cmd "ip addr add $ipvs_ip3/24 dev ${eth_use3}"
    P_SSH_CMD --node 4 --cmd "ip addr add $ipvs_ip4/24 dev ${eth_use4}"
    DNF_INSTALL "ipvsadm httpd firewalld"
    DNF_INSTALL "firewalld" 2
    DNF_INSTALL "firewalld" 3
    systemctl start httpd
    systemctl stop firewalld
    ipvsadm
    ipvsadm -C
}

function clean_tun_env() {
    echo "0" >/proc/sys/net/ipv4/ip_forward
    route del -host "$ipvs_vip" dev tunl0
    ip addr del "$ipvs_vip"/24 dev tunl0
    modprobe -r ipip
    P_SSH_CMD --node 2 --cmd "bash -x /tmp/LVS_TUN_RIP_config.sh stop"
    P_SSH_CMD --node 3 --cmd "bash -x /tmp/LVS_TUN_RIP_config.sh stop"
}

function clean_env() {
    if grep cloudroot /etc/passwd;then
        LOG_INFO "Network support is unavailable in the CloudPods environment."
        exit 255
    fi
    systemctl start firewalld
    systemctl stop httpd
    ipvsadm -C
    rm -rf /etc/sysconfig/ipvsadm ./result_*
    ip addr del "$ipvs_vip"/24 dev "${NODE1_NIC}"
    DNF_REMOVE "$@"
    DNF_REMOVE "$@" 2
    DNF_REMOVE "$@" 3
    P_SSH_CMD --node 2 --cmd "
    bash -x /tmp/LVS_DR_RIP_config.sh stop;
    ip addr del $ipvs_ip2/24 dev ${eth_use2};"
    P_SSH_CMD --node 3 --cmd "
    bash -x /tmp/LVS_DR_RIP_config.sh stop;
    ip addr del $ipvs_ip3/24 dev ${eth_use2};"
    P_SSH_CMD --node 4 --cmd "
    rm -rf /tmp/GET_CURL_RESULT.sh /tmp/result_curl.txt;
    ip addr del $ipvs_ip4/24 dev ${eth_use2}"
    ip addr del "$ipvs_ip1"/24 dev "${eth_use1}"
}
