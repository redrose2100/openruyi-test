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
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Check network status
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    cat /proc/net/raw >/dev/null
    CHECK_RESULT $? 0 0 "Check net raw failed."
    cat /proc/net/ptype >/dev/null
    CHECK_RESULT $? 0 0 "Check net ptype failed."
    cat /proc/net/snmp >/dev/null
    CHECK_RESULT $? 0 0 "Check statistic snmp failed."
    cat /proc/net/protocols >/dev/null
    CHECK_RESULT $? 0 0 "Check statistic protocols failed."
    grep -q ${NODE1_NIC} /proc/net/arp
    CHECK_RESULT $? 0 0 "Check support arp failed."

    LOG_INFO "End to run test."
}

main "$@"
