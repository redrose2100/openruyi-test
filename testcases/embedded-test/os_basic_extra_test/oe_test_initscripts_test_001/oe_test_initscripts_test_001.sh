#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run initscripts testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run initscripts test."
    # 检测到系统中存在systemctl则直接退出测试
    if command -v systemctl >/dev/null 2>&1; then
        LOG_INFO "系统中存在systemctl，退出initscripts测试"
        return 0
    fi
    ifconfig | grep "^lo"
    CHECK_RESULT $? 0 0 "check ifdown failed!"
    ifdown lo
    CHECK_RESULT $? 0 0 "check ifdown lo failed!"
    ifconfig | grep "^lo"
    CHECK_RESULT $? 1 0 "check ifconfig failed!"
    ifup lo
    CHECK_RESULT $? 0 0 "check ifup lo failed!"
    ifconfig | grep "^lo"
    CHECK_RESULT $? 0 0 "check ifconfig failed!"

    [ -x /etc/init.d/sendsigs ]
    CHECK_RESULT $? 0 0 "check initscripts_sendsigs failed!"
    [ -x /etc/init.d/halt ]
    CHECK_RESULT $? 0 0 "check initscripts halt failed!"
    LOG_INFO "End to run initscripts test."
}

main "$@"
