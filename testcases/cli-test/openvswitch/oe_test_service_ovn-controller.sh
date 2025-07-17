#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangdan
# @Contact   :   1743994506@qq.com
# @Date      :   2021/12/02
# @License   :   Mulan PSL v2
# @Desc      :   Test ovn-controller.service restart
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/openvswitch/common/checkenv.sh"


function pre_test() {
    # 如果openvswitch版本大于等于 2.12.0-22，跳过ovn测试用例。 因为此版本后ovn被移除。
    checkversion2120
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openvswitch-ovn-host
    service=ovn-controller.service
    log_time=$(date '+%Y-%m-%d %T')
    flag=false
    if getenforce | grep -q Enforcing ; then
        setenforce 0
        flag=true
    fi
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start testing..."
    service "${service}" restart
    CHECK_RESULT $? 0 0 "${service} restart failed"
    service "${service}" stop
    CHECK_RESULT $? 0 0 "${service} stop failed"
    service "${service}" start
    CHECK_RESULT $? 0 0 "${service} start failed"
    service "${service}" status | grep "Active: active (running)"
    CHECK_RESULT $? 0 0 "${service} start failed"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
    service "${service}" reload 2>&1 | grep "Job type reload is not applicable for unit ${service}"
    CHECK_RESULT $? 0 0 "${service} reload failed"
    LOG_INFO "Finish test!"
}


function post_test() {
    LOG_INFO "start environment cleanup."
    service "${service}" stop
    DNF_REMOVE
    if [ "${flag}" = 'true' ]; then
        setenforce 1
    fi
    LOG_INFO "Finish environment cleanup!"
}


main "$@"

