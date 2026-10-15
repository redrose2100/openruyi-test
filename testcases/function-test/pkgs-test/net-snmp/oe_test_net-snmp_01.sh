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
# @Date      :   2022/12/13
# @License   :   Mulan PSL v2
# @Desc      :   Test net-snmp function
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
dir_conf=/etc/snmp/snmpd.conf

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "net-snmp"
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
    snmpwalk -v2c -c public localhost .1 | grep "SNMPv2-MIB"
    CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v2c"
    snmpwalk -v 1 -c public localhost .1 | grep "SNMPv2-MIB"
    CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v1"
    snmpwalk -v 2c -c public localhost sysName | grep "SNMPv2-MIB::sysName.0"
    CHECK_RESULT $? 0 0 "Get hostname fail"
    snmpget -v 2c -c public localhost SNMPv2-MIB::sysName.0
    CHECK_RESULT $? 0 0 "Check SNMPv2-MIB::sysName.0 information fail"
    snmptranslate -Td SNMPv2-MIB::system
    CHECK_RESULT $? 0 0 "Get SNMPv2-MIB::sysName fail"
    mv -f snmpd.conf "${dir_conf}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
