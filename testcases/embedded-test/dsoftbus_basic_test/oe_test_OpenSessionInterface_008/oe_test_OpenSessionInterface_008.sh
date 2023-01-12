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

    chmod 777 OpenSessionInterface_008
    SSH_SCP OpenSessionInterface_008 root@${NODE2_IPV4}:/ "${NODE2_PASSWORD}"

    echo 123456 > /etc/SN
    SSH_CMD "echo 456789 > /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD} ${NODE2_USER}  300 22

    nohup softbus_server_main >/log.file 2>&1 &
    SSH_CMD "nohup softbus_server_main > /log.file 2>&1 &"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
     
    SSH_CMD "nohup /OpenSessionInterface_008 >/dev/null 2>&1 & "  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
	
    expect -v
    if [ $? -ne 0 ]; then
        LOG_ERROR "System not support expect"
        return 0
    fi

    expect << EOF
    set timeout 30
    spawn ./OpenSessionInterface_008
    expect {
      "SoftBusClientStub::OnReceived, code = 269" {send "c\r"}
      timeout { exit 1 }
    }
    expect {
      "OpenSessionInterface fail" { exit 0 }
      timeout { exit 1 }
    }
EOF

    CHECK_RESULT $? 0 0 "OpenSessionInterface_008 fail"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf /etc/SN
    SSH_CMD "rm -rf /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD} ${NODE2_USER} 300 22
 
    ps -ef | grep softbus_server_main |grep -v grep | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps -ef | grep OpenSessionInterface_008 |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "ps -ef | grep softbus_server_main |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    rm -rf /log.file
    SSH_CMD "rm -rf /OpenSessionInterface_008"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "rm -rf /log.file"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    
    rm -rf /data/data* 
    mkdir -p /data/data/deviceauth 
    SSH_CMD "rm -rf /data/data*"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "mkdir -p /data/data/deviceauth"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    LOG_INFO "End to restore the test environment."
}

main "$@"
