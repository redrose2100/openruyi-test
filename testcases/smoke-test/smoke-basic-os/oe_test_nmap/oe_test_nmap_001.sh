#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-07-04
# @License   :   Mulan PSL v2
# @Desc      :   Use nmap case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nmap"
    iptables -F
    systemctl stop firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ncat -l 8080 > /tmp/ncat_log 2>&1 &
    CHECK_RESULT $? 0 0 "Error,Fail to create /tmp/ncat_log"
    echo -e "123\\n456\\n004\\n" | ncat 127.0.0.1 8080
    CHECK_RESULT $? 0 0 "Error, please check port:8080"
    grep -icE '123|456|004' /tmp/ncat_log
    CHECK_RESULT $? 0 0 "Error, please check /tmp/ncat_log"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    systemctl restart firewalld
    rm /tmp/ncat_log
    LOG_INFO "End to restore the test environment."
}

main "$@"