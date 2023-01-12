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

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    chmod 777 DiscoveryInterface_002

    echo 123456 > /etc/SN
    
    softbus_server_main >/log.file 2>&1 &

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    ./DiscoveryInterface_002
    CHECK_RESULT $? 0 1 "Failed to execute the DiscoveryInterface_002 test case."

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf /etc/SN

    ps -ef | grep softbus_server_main |grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf /log.file
    
    rm -rf /data/data* 
    mkdir -p /data/data/deviceauth 

    LOG_INFO "End to restore the test environment."
}

main "$@"

