#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test haveged.service restart
# #############################################

source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh

function haveged_test_enabled() {
    service=$1
    state=$(systemctl is-enabled "${service}")
    if [ "${state}" == "enabled" ]; then
	symlink_file=$(systemctl disable "${service}" 2>&1 | grep "Removed" | awk '{print $2}' | 
		awk '{print substr($0,2,length($0)-3)}')
        find "${symlink_file}"
        CHECK_RESULT $? 0 1 "${service} disable failed"
        systemctl enable "${service}"
        find "${symlink_file}"
        CHECK_RESULT $? 0 0 "${service} enable failed"
    elif [ "${state}" == "disabled" ]; then
	symlink_file=$(systemctl enable "${service}" 2>&1 | grep "Created symlink" | awk '{print $3}')
        find "${symlink_file}"
        CHECK_RESULT $? 0 0 "${service} enable failed"
        systemctl disable "${service}"
        find "${symlink_file}"
        CHECK_RESULT $? 0 1 "${service} disable failed"
    elif [ "${state}" == "masked" ]; then
        LOG_INFO "Unit is masked, ignoring."
    elif [ "${state}" == "static" ]; then
        LOG_INFO "The unit files have no installation config,This means they are not meant to be enabled using systemctl."
    else
        LOG_INFO "Unit is indirect, ignoring."
    fi
}

function haveged_test_execution() {
    service=$1
    log_time=$(date '+%Y-%m-%d %T')
    test_restart "${service}"
    haveged_test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL haveged
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    if [ "$(uname -m)" == "riscv64" ]; then
        haveged_test_execution haveged.service
    else
        test_execution haveged.service
    fi
    test_reload haveged.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE 1 haveged
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
