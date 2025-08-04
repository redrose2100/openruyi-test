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
# shellcheck disable=SC1091,SC2154
source ../common/common_ipvs.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_env
    ip addr add "$ipvs_vip"/24 dev "${NODE1_NIC}"
    ipvsadm -A -t "$ipvs_vip":80 -s rr
    ipvsadm -a -t "$ipvs_vip":80 -r "$ipvs_ip2":80 -g
    ipvsadm -a -t "$ipvs_vip":80 -r "$ipvs_ip3":80 -g
    SLEEP_WAIT 10
    ipvsadm-save >/etc/sysconfig/ipvsadm
    SLEEP_WAIT 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SFTP put --localdir ./../common --localfile LVS_DR_RIP_config.sh --remotedir /tmp --node 2
    P_SSH_CMD --node 2 --cmd "
    sed -i 's/ipvs_vip/$ipvs_vip/g' /tmp/LVS_DR_RIP_config.sh;
    sed -i 's/ipvs_eth/$NODE2_NIC/g' /tmp/LVS_DR_RIP_config.sh;
    sed -i 's/serveripvs_ip/$ipvs_ip2/g' /tmp/LVS_DR_RIP_config.sh;
    bash -x /tmp/LVS_DR_RIP_config.sh start;"
    SFTP put --localdir ./../common --localfile LVS_DR_RIP_config.sh --remotedir /tmp --node 3
    P_SSH_CMD --node 3 --cmd "
    sed -i 's/ipvs_vip/$ipvs_vip/g' /tmp/LVS_DR_RIP_config.sh;
    sed -i 's/ipvs_eth/$NODE3_NIC/g' /tmp/LVS_DR_RIP_config.sh;
    sed -i 's/serveripvs_ip/$ipvs_ip3/g' /tmp/LVS_DR_RIP_config.sh;
    bash -x /tmp/LVS_DR_RIP_config.sh start;"
    SFTP put --localdir ./../common --localfile GET_CURL_RESULT.sh --remotedir /tmp --node 4
    P_SSH_CMD --node 4 --cmd "
    sed -i 's/ipvs_vip/$ipvs_vip/g' /tmp/GET_CURL_RESULT.sh;
    bash -x /tmp/GET_CURL_RESULT.sh;"
    SFTP get --localdir ./ --remotefile result_curl.txt --remotedir /tmp --node 4
    CHECK_RESULT "$(grep -cE "${ipvs_ip2}" ./result_curl.txt)" 3
    CHECK_RESULT "$(grep -cE "${ipvs_ip3}" ./result_curl.txt)" 3
    P_SSH_CMD --node 2 --cmd "systemctl stop httpd"
    SLEEP_WAIT 2
    P_SSH_CMD --node 4 --cmd "rm -rf /tmp/result_curl.txt && bash -x /tmp/GET_CURL_RESULT.sh;mv /tmp/result_curl.txt /tmp/result_curl1.txt"
    SFTP get --localdir ./ --remotefile result_curl1.txt --remotedir /tmp --node 4
    CHECK_RESULT "$(grep -cE "${ipvs_ip2}" ./result_curl1.txt)" 0
    CHECK_RESULT "$(grep -cE "${ipvs_ip3}" ./result_curl1.txt)" 3
    SLEEP_WAIT 2
    P_SSH_CMD --node 3 --cmd "systemctl stop httpd"
    SLEEP_WAIT 2
    P_SSH_CMD --node 4 --cmd "rm -rf /tmp/result_curl.txt && bash -x /tmp/GET_CURL_RESULT.sh;mv /tmp/result_curl.txt /tmp/result_curl1.txt"
    SFTP get --localdir ./ --remotefile result_curl1.txt --remotedir /tmp --node 4
    CHECK_RESULT "$(grep -cE "${ipvs_ip2}" ./result_curl1.txt)" 0
    CHECK_RESULT "$(grep -cE "${ipvs_ip3}" ./result_curl1.txt)" 0
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_env
    LOG_INFO "End to restore the test environment."
}
main "$@"
