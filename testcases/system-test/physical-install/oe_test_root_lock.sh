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
# @Desc      :   root lock
# ############################################
# shellcheck disable=SC2034,SC2154,SC1091

source ./common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_env
    EXECUTE_T="120m"
    
    sed -i "s#network_url#$http_url#g" /var/www/html/anaconda-ks-base.cfg
    sed -i "s/rootpw/#/g"  /var/www/html/anaconda-ks-base.cfg
    SM3_PASS="$(python3 -c "import crypt; print(crypt.crypt('${NODE3_PASSWORD}', '\$sm3\$iWx6/anBGfyOWXDD\$'))")"
    sed -i "/Root password/a rootpw --lock\nuser --groups=wheel,example2 --homedir=/home/example1 --name=example --password=${SM3_PASS} --iscrypted --gecos=example" /var/www/html/anaconda-ks-base.cfg
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
            sed -i "/${NODE3_IPV4}/d" /root/.ssh/known_hosts
            SSH_CMD "pwd" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "example" | grep example1
            CHECK_RESULT $?
            SSH_CMD "cat /etc/group" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "example" | grep example2
            CHECK_RESULT $?
            SSH_CMD "uname -a" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_PASSWORD}"
            CHECK_RESULT $? 0 1
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
