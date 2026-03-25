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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   MARIADB software compatibility
# #############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    RANDOM_IP() {
        while true; do
            random_ip=192.168.122.$(shuf -e $(seq 1 254) | head -n 1)
    	    ping -c 3 "${random_ip}" &>/dev/nul || {
                printf "%s" "$random_ip"
                break
            }
        done
    }
    #如果是qemu环境下，额外添加ip地址添加在eth2上
    if [ "$(systemd-detect-virt)" = "qemu" ]; then
	eth_use1="eth2"
	eth_use2="eth2"
    else
        eth_use1=$(TEST_NIC 1 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
        eth_use2=$(TEST_NIC 2 | grep -v -E 'lo|bond|virbr|vnet|br\\[0-9\\]|docker|br-|veth|tun' | awk '{print $NF}')
    fi
    temp_ip1=$(RANDOM_IP)
    ip addr add "${temp_ip1}"/24 dev "${eth_use1}"
    temp_ip2=$(RANDOM_IP)
    P_SSH_CMD --node 2 --cmd "ip addr add ${temp_ip2}/24 dev ${eth_use2}"
    DNF_INSTALL "net-tools mariadb-server"
    rm -rf /var/lib/mysql/*
    systemctl start mariadb.service
    systemctl status mariadb.service | grep running || exit 1
    mysqladmin -uroot password "${NODE1_PASSWORD}"
    #检查iptables-legacy规则是否有REJECT规则，若存在需要临时放行mysql 3306端口
    added_rule=0
    if command -v iptables-legacy >/dev/null 2>&1 && iptables-legacy -L INPUT -n | grep -q "REJECT.*icmp-host-prohibited"; then
       if ! iptables-legacy -L INPUT -n | grep "dpt:3306"; then
           echo "[*] Allowing HTTP (port 3306)..."
           iptables-legacy -I INPUT -p tcp --dport 3306 -j ACCEPT
           added_rule=1
       fi
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    systemctl restart mariadb
    CHECK_RESULT $?
    netstat -anp | grep 3306
    CHECK_RESULT $?
    expect -c "
        set timeout 100
        spawn mysql -u root -p
        expect {
            \"Enter*\" { send \"${NODE1_PASSWORD}\r\";
            expect \"Maria*\" { send \"grant all privileges on *.* to 'root'@'$temp_ip2' IDENTIFIED BY '$NODE2_PASSWORD' WITH GRANT OPTION;\r\"}
            expect \"Maria*\" { send \"flush privileges;\r\"}
            expect \"Maria*\" { send \"exit\r\"}
    }
    }
    expect eof
    "
    SLEEP_WAIT 5
    systemctl restart mariadb
    CHECK_RESULT $?
    systemctl stop firewalld
    SSH_CMD "dnf -y install mariadb-server expect" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl start mariadb;systemctl stop firewalld" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    cp ../common/mariadb_remote .
    SSH_SCP ./mariadb_remote "${NODE2_USER}"@"${NODE2_IPV4}":/opt/ "${NODE2_PASSWORD}"
    P_SSH_CMD --node 2 --cmd "NODE1_IPV4='${temp_ip1}' NODE1_PASSWORD='${NODE1_PASSWORD}' expect /opt/mariadb_remote;grep 'Query OK' /opt/testlog"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /var/lib/mysql mariadb_remote
    #删除放行的http 3306端口
    if  [ "$added_rule" -eq 1 ]; then
        echo "[*] Removing temporary rule for port 3306..."
        iptables-legacy -D INPUT -p tcp --dport 3306 -j ACCEPT
    fi 
    ip addr del "${temp_ip1}"/24 dev "${eth_use1}"
    SSH_CMD "yum remove mariadb-server expect -y;rm -rf /opt/mariadb_remote /opt/testlog;ip addr del ${temp_ip2}/24 dev ${eth_use2};" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
