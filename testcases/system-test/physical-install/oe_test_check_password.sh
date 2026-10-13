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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2023/07/06
# @License   :   Mulan PSL v2
# @Desc      :   Check password
# ############################################
# shellcheck disable=SC2034,SC2154,SC1091

source ./common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_env
    sed -i "s#network_url#$http_url#g" /var/www/html/anaconda-ks-base.cfg
    chmod  777 /var/www/html/anaconda-ks-base.cfg
    systemctl restart httpd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE3_MACHINE}" == "kvm" ]; then
        LOG_WARN "This machine is not a physical machine."
    else
        if [ "$NODE3_IPV4"x == "$server_ip"x ]; then
            LOG_INFO "The third machine is the tftp server."
        else
            ipmitool -H ${NODE3_BMC_IP} -I lanplus -U ${NODE3_BMC_USER} -P ${NODE3_BMC_PASSWORD} chassis bootdev pxe
            SLEEP_WAIT 5
            ipmitool -H ${NODE3_BMC_IP} -I lanplus -U ${NODE3_BMC_USER} -P ${NODE3_BMC_PASSWORD} chassis power reset
            SLEEP_WAIT 1200
            ipmitool -H ${NODE3_BMC_IP} -I lanplus -U ${NODE3_BMC_USER} -P ${NODE3_BMC_PASSWORD} power status | grep "Chassis Power is on" || SLEEP_WAIT 300
            P_SSH_CMD --cmd "ping -c 3 ${NODE1_IPV4} >/dev/null" --node 3 || SLEEP_WAIT 300
            P_SSH_CMD --cmd "grep -riE \"huawei|openeuler\" /tmp/| grep -vE \"/dev/mapper/openeuler|openEuler-logos-httpd\" | wc -l | grep 0" --node 3
            CHECK_RESULT $?
            P_SSH_CMD --cmd "grep root /etc/shadow |grep -iE \"\$5|\$6|\$y\"" --node 3
            CHECK_RESULT $?
        fi
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clean_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
