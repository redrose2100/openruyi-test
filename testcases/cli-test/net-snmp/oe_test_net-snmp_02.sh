#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2022/12/14
# @License   :   Mulan PSL v2
# @Desc      :   Test net-snmp function of checking the MIB objects by remote client
# #############################################

source "../common/common_lib.sh"
dir_conf=/etc/snmp/snmpd.conf

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL net-snmp
    DNF_INSTALL net-snmp 2
    which firewalld && systemctl stop firewalld
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ls -l "${dir_conf}"
    CHECK_RESULT $? 0 0 "snmpd.conf file not exist"
    cp -ar "${dir_conf}" snmpd.conf
    echo 'com2sec notConfigUser  default       public
group   notConfigGroup v1           notConfigUser
group   notConfigGroup v2c           notConfigUser
view  all      included        .1
access notConfigGroup "" any noauth exact systemview systemview none' >> "${dir_conf}"
    systemctl restart snmpd.service
    CHECK_RESULT $? 0 0 "snmpd.service restart fail"
    SSH_CMD "snmpwalk -v2c -c public ${NODE1_IPV4} .1 | grep SNMPv2-MIB" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v2c"
    SSH_CMD "snmpwalk -v 1 -c public ${NODE1_IPV4} .1 | grep SNMPv2-MIB" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v1"
    mv -f snmpd.conf "${dir_conf}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    DNF_REMOVE 2
    which firewalld && systemctl start firewalld
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
