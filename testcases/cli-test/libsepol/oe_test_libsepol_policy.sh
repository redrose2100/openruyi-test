#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/16
# @License   :   Mulan PSL v2
# @Desc      :   Test SELinux policy operations: create, load, modify and query
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_POLICY_DIR="/tmp/libsepol_test_$(date +%s)"
    TEST_MOD_CONF="${TEST_POLICY_DIR}/test_module.conf"
    TEST_POLICY_FILE="${TEST_POLICY_DIR}/test_policy"
    POLICY_FILE="/etc/selinux/targeted/policy/policy.33"
    if [ ! -f "${POLICY_FILE}" ]; then
        POLICY_FILE=$(find /etc/selinux -name "policy.*" 2>/dev/null | head -1)
    fi
    if ! rpm -ql libsepol libsepol-devel | grep bin | grep sepol;then
        LOG_INFO "This version has no commands and is not supported."
        exit 255
    fi
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libsepol checkpolicy policycoreutils"
    mkdir -p "${TEST_POLICY_DIR}"
    if [ -z "${POLICY_FILE}" ] || [ ! -f "${POLICY_FILE}" ]; then
        LOG_INFO "SELinux policy file not found, skipping policy operations tests"
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Create a simple SELinux policy module source file (using traditional .conf format, include require section)
    cat > "${TEST_MOD_CONF}" <<EOF
module test_policy 1.0;

require {
    type unconfined_t;
    type etc_t;
    class file { read write };
}

allow unconfined_t etc_t:file { read write };
EOF
    # Use checkpolicy to compile the policy module into binary policy
    checkmodule -M -m -o "${TEST_POLICY_FILE}.mod" "${TEST_MOD_CONF}"
    CHECK_RESULT $? 0 0 "checkmodule compilation failed"
    # Create policy package
    semodule_package -o "${TEST_POLICY_FILE}.pp" -m "${TEST_POLICY_FILE}.mod"
    CHECK_RESULT $? 0 0 "semodule_package creation failed"
    # Load policy module
    semodule -i "${TEST_POLICY_FILE}.pp"
    CHECK_RESULT $? 0 0 "semodule load failed"
    # Query loaded policy modules
    semodule -l | grep -q "test_policy"
    CHECK_RESULT $? 0 0 "test_policy module not found after loading"
    # Use sepol_check_access to verify new policy rules
    sepol_check_access "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file read | grep "requested permission read allowed"
    CHECK_RESULT $? 0 0 "sepol_check_access with test policy failed"
    # Modify policy module: add new permissions
    cat > "${TEST_MOD_CONF}" <<EOF
module test_policy 1.1;

require {
    type unconfined_t;
    type etc_t;
    class file { read write execute };
}

allow unconfined_t etc_t:file { read write execute };
EOF
    CHECK_RESULT $? 0 0 "updated policy module creation failed"
    # Recompile and load updated policy
    checkmodule -M -m -o "${TEST_POLICY_FILE}.mod" "${TEST_MOD_CONF}"
    CHECK_RESULT $? 0 0 "updated checkmodule compilation failed"
    semodule_package -o "${TEST_POLICY_FILE}.pp" -m "${TEST_POLICY_FILE}.mod"
    CHECK_RESULT $? 0 0 "updated semodule_package creation failed"
    semodule -i "${TEST_POLICY_FILE}.pp"
    CHECK_RESULT $? 0 0 "updated semodule load failed"
    # Verify updated policy rules
    sepol_check_access "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file execute | grep "requested permission execute allowed"
    CHECK_RESULT $? 0 0 "sepol_check_access with execute permission failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    semodule -r test_policy 2>/dev/null || true
    rm -rf "${TEST_POLICY_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"