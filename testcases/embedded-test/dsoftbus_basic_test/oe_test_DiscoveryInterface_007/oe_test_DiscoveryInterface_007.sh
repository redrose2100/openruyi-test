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
#@Author    	:   seven
#@Contact   	:   2461603862@qq.com
#@Date      	:   2023-01-12
#@License   	:   Mulan PSL v2
#@Desc      	:   Test dsoftbus interface
#####################################

source ../comm_lib_single.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    pre_dsoftbus DiscoveryInterface_007

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    ./DiscoveryInterface_007
    CHECK_RESULT $? 0 1 "Failed to execute the DiscoveryInterface_007 test case."

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    clean_dsoftbus

    LOG_INFO "End to restore the test environment."
}

main "$@"

