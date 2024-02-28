#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2022-11-02
# @License   :   Mulan PSL v2
# @Desc      :   Command test-systool  
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    DNF_INSTALL sysfsutils
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systool -b pci -v  | awk -F: '{print $0}' |grep pci
    CHECK_RESULT $? 0 0  "check systool result fail"
    systool --help | grep "Usage: systool"
    CHECK_RESULT $? 0 0 "check systool's help manual fail"
    systool -c net -v |grep 'Class Device = "lo"'
    CHECK_RESULT $? 0 0 "Querying network devices fail"
    systool -b scsi -c scsi_host |grep 'Class = "scsi_host"'
    CHECK_RESULT $? 0 0 "Failed to query the information and attributes of the SCSI host"
    systool -c net -p /sys/class/net/lo/ |grep 'Class = "net"'
    CHECK_RESULT $? 0 0 "Failed to query the specified network interface"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"