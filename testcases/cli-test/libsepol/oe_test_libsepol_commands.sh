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
# @Desc      :   Test libsepol commands: sepol_check_access, sepol_compute_av, sepol_compute_member, sepol_compute_relabel, sepol_validate_transition
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    POLICY_FILE="/etc/selinux/targeted/policy/policy.33"
    if [ ! -f "${POLICY_FILE}" ]; then
        POLICY_FILE=$(find /etc/selinux -name "policy.*" 2>/dev/null | head -1)
    fi
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libsepol"
    if [ -z "${POLICY_FILE}" ] || [ ! -f "${POLICY_FILE}" ]; then
        LOG_INFO "SELinux policy file not found, skipping command tests"
        exit 255
    fi
    if ! rpm -ql libsepol libsepol-devel | grep bin | grep sepol;then
        LOG_INFO "This version has no commands and is not supported."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # unconfined_t should have permission to read etc_t (policy allows)
    sepol_check_access "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file read | grep "requested permission read allowed"
    CHECK_RESULT $? 0 0 "sepol_check_access should allow unconfined_t to read etc_t"
    
    # unconfined_t should have permission to write etc_t (policy allows)
    sepol_check_access "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file write | grep "requested permission write allowed"
    CHECK_RESULT $? 0 0 "sepol_check_access should allow unconfined_t to write etc_t"
    
    # user_t should not have permission to read shadow_t (policy denies)
    sepol_check_access "${POLICY_FILE}" system_u:system_r:user_t:s0 system_u:object_r:shadow_t:s0 file read
    CHECK_RESULT $? 0 1 "sepol_check_access should deny user_t to read shadow_t"
    
    # user_t should not have permission to write shadow_t (policy denies)
    sepol_check_access "${POLICY_FILE}" system_u:system_r:user_t:s0 system_u:object_r:shadow_t:s0 file write
    CHECK_RESULT $? 0 1 "sepol_check_access should deny user_t to write shadow_t"
    
    # Test sepol_compute_av: Compute access vector, verify return result
    sepol_compute_av "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file | grep -iqE "^allow"
    CHECK_RESULT $? 0 0 "sepol_compute_av should produce valid output"
    
    # Test sepol_compute_member: Compute label context for multi-instance objects
    sepol_compute_member "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:user_home_dir_t:s0 dir | grep -qE "^[a-zA-Z0-9_]+:[a-zA-Z0-9_]+:[a-zA-Z0-9_]+:s[0-9]"
    CHECK_RESULT $? 0 0 "sepol_compute_member output is not a valid context"
    
    # Test sepol_compute_relabel: Compute new context when relabeling objects
    sepol_compute_relabel "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file | grep -qE "^[a-zA-Z0-9_]+:[a-zA-Z0-9_]+:[a-zA-Z0-9_]+:s[0-9]"
    CHECK_RESULT $? 0 0 "sepol_compute_relabel output is not a valid context"
    
    # Test sepol_validate_transition: Verify if type transition is valid
    sepol_validate_transition "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file system_u:object_r:etc_t:s0 | grep -iq "allowed"
    CHECK_RESULT $? 0 0 "sepol_validate_transition should succeed for valid transition"
    
    # Test invalid parameter scenarios
    sepol_check_access "${POLICY_FILE}" invalid_context system_u:object_r:etc_t:s0 file read
    CHECK_RESULT $? 0 1 "sepol_check_access should fail with invalid context"
    
    sepol_check_access "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file invalid_perm
    CHECK_RESULT $? 0 1 "sepol_check_access should fail with invalid permission"
    
    sepol_compute_av "${POLICY_FILE}" invalid_context system_u:object_r:etc_t:s0 file
    CHECK_RESULT $? 0 1 "sepol_compute_av should fail with invalid context"
    
    sepol_validate_transition "${POLICY_FILE}" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file invalid_context:s0
    CHECK_RESULT $? 0 1 "sepol_validate_transition should fail with invalid new context"
    
    # Test wrong policy file path
    sepol_check_access "/nonexistent/policy" system_u:system_r:unconfined_t:s0 system_u:object_r:etc_t:s0 file read
    CHECK_RESULT $? 0 1 "sepol_check_access should fail with nonexistent policy file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"