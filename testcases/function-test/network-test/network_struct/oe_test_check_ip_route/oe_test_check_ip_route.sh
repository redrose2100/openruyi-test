#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Check ip route show
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function run_test() {
    LOG_INFO "Start to run test."
    ip route show | grep "${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "Check ip route show failed."
    ip route get "${NODE1_IPV4}" | grep "local ${NODE1_IPV4}"
    CHECK_RESULT $? 0 0 "Check ip route show failed."
    LOG_INFO "End to run test."
}

main "$@"
