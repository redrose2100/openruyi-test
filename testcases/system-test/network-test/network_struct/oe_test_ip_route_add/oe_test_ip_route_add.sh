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
#@Date      	:   2021-08-09
#@License   	:   Mulan PSL v2
#@Desc      	:   Check ip route set
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    add_ip=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).105
    
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    ip route add $add_ip via ${NODE1_IPV4} dev ${NODE1_NIC}
    CHECK_RESULT $? 0 0 "Add ip route failed."
    ip route show | grep $add_ip
    CHECK_RESULT $? 0 0 "Check add ip route failed."

    ip route del $add_ip
    CHECK_RESULT $? 0 0 "Delete ip route failed."
    ip route show | grep $add_ip
    CHECK_RESULT $? 1 0 "Check delete ip route failed."

    LOG_INFO "End to run test."
}

main "$@"
