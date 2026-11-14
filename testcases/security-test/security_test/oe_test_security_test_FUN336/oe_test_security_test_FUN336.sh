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
#@Desc      	:   Take the test ls command as an example
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # SSH_CMD 走 expect 包装的 ssh/scp，运行器默认未预装 openssh-clients，
    # 节点 1 必须先本地装上才能继续向节点 2 下发命令。
    DNF_INSTALL "openssh-clients"
    DNF_INSTALL "openssh-clients" 2

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    SSH_CMD "pwd" "$NODE2_IPV4" "$NODE2_PASSWORD" "$NODE2_USER"
    CHECK_RESULT $? 0 0 "ssh failed"
    
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE 2 "$@"
    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"
