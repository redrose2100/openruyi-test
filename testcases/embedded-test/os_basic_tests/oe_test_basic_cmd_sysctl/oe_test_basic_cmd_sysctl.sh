#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   SYSCTL modifies kernel parameters
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    if [ -e /proc/sys/net/ipv6 ]; then
        test_param="net.ipv6.conf.lo.disable_ipv6"
    else
        test_param="net.ipv4.ip_forward"
    fi

    CHECK_RESULT "$(sysctl -a | grep -ioE 'dev|kernel|net' | sort -u | wc -l)" 3 0 "run sysctl -a | grep -ioE 'dev|kernel|net' fail"
    sysctl ${test_param}=1
    CHECK_RESULT $? 0 0 "run sysctl set ${test_param}=1 fail"
    CHECK_RESULT "$(sysctl -a | grep -w ${test_param} | awk '{print$3}')" 1 0 "check ${test_param} set to 1 fail"
    sysctl -w ${test_param}=0
    CHECK_RESULT $? 0 0 "run sysctl -w ${test_param}=0 fail"
    CHECK_RESULT "$(sysctl -a | grep -w ${test_param} | awk '{print$3}')" 0 0 "check ${test_param} set to 0 fail"

    LOG_INFO "End of run test."
}

main $@
