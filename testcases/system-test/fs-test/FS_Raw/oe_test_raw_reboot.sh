#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-04
#@License   	:   Mulan PSL v2
#@Desc      	:   raw and reboot
#####################################

source ../common_lib/fsio_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "raw /dev/raw/raw1 1 1"
    CHECK_RESULT $? 0 0 "Create /dev/raw/raw1 failed."
    ssh_cmd_node "blockdev --report /dev/raw/raw1"
    CHECK_RESULT $? 0 0 "Check report for /dev/raw/raw1 failed."
    ssh_cmd_node "raw -qa | grep /dev/raw/raw1"
    CHECK_RESULT $? 0 0 "Check /dev/raw/raw1 failed."
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    ssh_cmd_node "raw -qa | grep /dev/raw/raw1"
    CHECK_RESULT $? 1 0 "Check /dev/raw/raw1 exist unexpectly."
    LOG_INFO "End to run test."
}

main "$@"

