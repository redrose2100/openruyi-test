#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   IPsec protocol
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "strongswan"
    # strongswan 同时提供 strongswan.service 与 strongswan-starter.service，
    # 部分构建里只有一个被 enable（原脚本写死 strongswan，实测报
    # "Unit strongswan.service not found"）。这里挑一个真实存在的单元名。
    # 注意 systemctl list-unit-files <name> 找不到时也返回 0，必须 grep 结果。
    if systemctl list-unit-files strongswan.service 2>/dev/null | grep -q '^strongswan\.service'; then
        SWAN_SERVICE=strongswan
    else
        SWAN_SERVICE=strongswan-starter
    fi
    LOG_INFO "Using service unit: ${SWAN_SERVICE}"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    systemctl start "${SWAN_SERVICE}"
    CHECK_RESULT $? 0 0 "start failed"
    systemctl status "${SWAN_SERVICE}" | grep active
    CHECK_RESULT $? 0 0 "grep active failed"
    
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    
    systemctl stop "${SWAN_SERVICE}" 2>/dev/null
    DNF_REMOVE
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
