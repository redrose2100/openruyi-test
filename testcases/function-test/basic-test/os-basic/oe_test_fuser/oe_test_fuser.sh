#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-05-29
#@License   	:   Mulan PSL v2
#@Desc      	:   test fuser
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    mapfile -t udp_port < <(ss -tuln | grep udp | awk '{print $5}' | awk -F":" '{print $NF}')
    mapfile -t tcp_port < <(ss -tuln | grep tcp | awk '{print $5}' | awk -F":" '{print $NF}')
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fuser -l
    CHECK_RESULT $? 0 0  "check arguments -l fail"
    fuser -u "/bin/bash"
    CHECK_RESULT $? 0 0  "check arguments -u fail"
    fuser -m -v /
    CHECK_RESULT $? 0 0  "check arguments -m fail"
    for u in "${udp_port[@]}";do
        fuser -n udp "${u}"
        CHECK_RESULT $? 0 0  "check udp port fail"
    done
    for t in "${tcp_port[@]}";do
        fuser -n tcp "${t}"
        CHECK_RESULT $? 0 0  "check tcp port fail"
    done
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    unset udp_port
    unset tcp_port
    unset mapfile
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring environment."
}

main "$@"



