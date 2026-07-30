#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/27
# @License   :   Mulan PSL v2
# @Desc      :   Verify bridge-utils brctl configuration operations (setfd, sethello, setmaxage, setageing, hairpin, setpathcost, setportprio, setbridgeprio)
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bridge-utils"
    bridge_name="testbr2"
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    if [ -z "${test_nic}" ]; then
        LOG_ERROR "No available NIC for testing"
        exit 1
    fi
    brctl addbr "${bridge_name}"
    brctl addif "${bridge_name}" "${test_nic}"
    export bridge_name test_nic
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    brctl show "${bridge_name}" | grep "${test_nic}"
    CHECK_RESULT $? 0 0 "Failed to verify NIC added to bridge"
    brctl setfd "${bridge_name}" 10
    CHECK_RESULT $? 0 0 "Failed to set forward delay"
    cat "/sys/class/net/${bridge_name}/bridge/forward_delay" | grep "1000"
    CHECK_RESULT $? 0 0 "Failed to verify forward delay"
    brctl sethello "${bridge_name}" 2
    CHECK_RESULT $? 0 0 "Failed to set hello time"
    cat "/sys/class/net/${bridge_name}/bridge/hello_time" | grep "200"
    CHECK_RESULT $? 0 0 "Failed to verify hello time"
    brctl setmaxage "${bridge_name}" 20
    CHECK_RESULT $? 0 0 "Failed to set max age"
    cat "/sys/class/net/${bridge_name}/bridge/max_age" | grep "2000"
    CHECK_RESULT $? 0 0 "Failed to verify max age"
    brctl setageing "${bridge_name}" 300
    CHECK_RESULT $? 0 0 "Failed to set ageing time"
    cat "/sys/class/net/${bridge_name}/bridge/ageing_time" | grep "30000"
    CHECK_RESULT $? 0 0 "Failed to verify ageing time"
    brctl hairpin "${bridge_name}" "${test_nic}" on
    CHECK_RESULT $? 0 0 "Failed to enable hairpin"
    cat "/sys/class/net/${test_nic}/brport/hairpin_mode" | grep "1"
    CHECK_RESULT $? 0 0 "Failed to verify hairpin mode"
    brctl setpathcost "${bridge_name}" "${test_nic}" 100
    CHECK_RESULT $? 0 0 "Failed to set path cost"
    brctl showstp "${bridge_name}" | grep -A5 "${test_nic}" | grep "path cost" | grep "100"
    CHECK_RESULT $? 0 0 "Failed to verify path cost"
    brctl setportprio "${bridge_name}" "${test_nic}" 32
    CHECK_RESULT $? 0 0 "Failed to set port priority"
    cat /sys/class/net/${test_nic}/brport/priority | grep "32"
    CHECK_RESULT $? 0 0 "Failed to verify port priority"
    brctl setbridgeprio "${bridge_name}" 32768
    CHECK_RESULT $? 0 0 "Failed to set bridge priority"
    cat "/sys/class/net/${bridge_name}/bridge/priority" | grep "32768"
    CHECK_RESULT $? 0 0 "Failed to verify bridge priority"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    brctl hairpin "${bridge_name}" "${test_nic}" off 2>/dev/null || true
    brctl delif "${bridge_name}" "${test_nic}" 2>/dev/null || true
    brctl delbr "${bridge_name}" 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
