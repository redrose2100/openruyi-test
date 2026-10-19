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
#@Desc      	:   Check ping ip
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ethtool "${NODE1_NIC}" | grep -q "Speed"
    CHECK_RESULT $? 0 0 "Check basic settings for ${NODE1_NIC} failed."
    ethtool -i "${NODE1_NIC}" | grep -q "driver"
    CHECK_RESULT $? 0 0 "Check info for ${NODE1_NIC} failed."
    ethtool -S "${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "get send and receive pkg from ${NODE1_NIC} failed."
    LOG_INFO "End to run test."
}

main "$@"
