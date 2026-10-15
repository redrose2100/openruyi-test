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
# @Desc      :   Verify bridge-utils brctl interface operations (delif, stp on/off, showstp, showmacs)
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bridge-utils"
    bridge_name="testbr1"
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
    brctl delif "${bridge_name}" "${test_nic}"
    CHECK_RESULT $? 0 0 "Failed to remove NIC ${test_nic} from bridge ${bridge_name}"
    brctl show "${bridge_name}" | grep "${test_nic}"
    CHECK_RESULT $? 1 0 "Failed to verify NIC removed from bridge"
    brctl stp "${bridge_name}" on
    CHECK_RESULT $? 0 0 "Failed to enable STP on ${bridge_name}"
    grep "1" < "/sys/class/net/${bridge_name}/bridge/stp_state"
    CHECK_RESULT $? 0 0 "Failed to verify STP enabled"
    brctl stp "${bridge_name}" off
    CHECK_RESULT $? 0 0 "Failed to disable STP on ${bridge_name}"
    grep "0" < "/sys/class/net/${bridge_name}/bridge/stp_state"
    CHECK_RESULT $? 0 0 "Failed to verify STP disabled"
    brctl showstp "${bridge_name}" | grep -E "bridge id|forward delay"
    CHECK_RESULT $? 0 0 "Failed to show STP status"
    brctl showmacs "${bridge_name}" | grep -E "port|mac"
    CHECK_RESULT $? 0 0 "Failed to show MAC addresses"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    brctl delif "${bridge_name}" "${test_nic}" 2>/dev/null || true
    brctl delbr "${bridge_name}" 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
