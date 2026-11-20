#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/11
# @License   :   Mulan PSL v2
# @Desc      :   iw device info query, mesh operations, event monitoring and regulatory domain test
# ############################################

source "${OET_PATH}"/testcases/function-test/pkgs-test/iw/common_lib_iw.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    iw_deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # iw dev <devname> info - show interface information
    iw dev "$HWSIM_DEV" info | grep -i "$HWSIM_DEV"
    CHECK_RESULT $? 0 0 "iw dev info command failed"
    # iw dev <devname> link - print link information
    iw dev "$HWSIM_DEV" link | grep "connected"
    CHECK_RESULT $? 0 0 "iw dev link command failed"
    # iw dev <devname> survey dump - channel survey data
    iw dev "$HWSIM_DEV" scan
    iw dev "$HWSIM_DEV" survey dump | grep -i "Survey"
    CHECK_RESULT $? 0 0 "iw dev survey dump command failed"
    # iw dev <devname> mpath dump - list mesh paths
    iw dev "$HWSIM_DEV" mpath dump | grep -i "metric"
    CHECK_RESULT $? 0 0 "iw dev mpath dump command failed"
    # iw dev <devname> mpp dump - list mesh proxy paths
    iw dev "$HWSIM_DEV" mpp dump | grep -i "proxy"
    CHECK_RESULT $? 0 0 "iw dev mpp dump command failed"
    # iw dev <devname> get mesh_param - retrieve mesh parameters
    iw dev "$HWSIM_DEV" get mesh_param | grep -i "mesh_"
    CHECK_RESULT $? 0 0 "iw dev get mesh_param command failed"
    # iw event -t - event with timestamp
    iw dev "$HWSIM_DEV" connect "test-network"
    timeout --foreground 10 iw event -t  | grep -E "^[0-9]+\.[0-9]+:"
    CHECK_RESULT $? 0 0 "iw event -t start check"
    # iw event -r - event with relative timestamp
    iw dev "$HWSIM_DEV" connect "test-network"
    timeout --foreground 10 iw event -r  | grep -E "\.[0-9]+:"
    CHECK_RESULT $? 0 0 "iw event -r start check"
    # iw event -f - event with full frame
    iw dev "$HWSIM_DEV" connect "test-network"
    timeout --foreground 10 iw event -f  | grep "scan"
    CHECK_RESULT $? 0 0 "iw event -f start check"
    # iw reg get - show regulatory domain
    iw reg get | grep -i "country"
    CHECK_RESULT $? 0 0 "iw reg get verification failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    iw_clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
