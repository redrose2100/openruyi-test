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
#@Author        :   seven
#@Contact       :   2461603862@qq.com
#@Date          :   2023-09-25
#@License       :   Mulan PSL v2
#@Desc          :   Test dsoftbus function
#####################################

# shellcheck disable=SC1091
source ../common/comm_lib_pair.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    pre_dsoftbus FunctionNetwork_003

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    SSH_CMD "nohup /FunctionNetwork_003 >/dev/null 2>&1 & " "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22

    expect_test
    expect << EOF
    set timeout 300
    spawn ./FunctionNetwork_003
    expect {
      "Input c to commnuication, Input s to stop:" {send "c\r"}
      timeout { exit 1 }
    }
    expect {
      "GetAllNodeDeviceInfo fail" { exit 0 }
      timeout { exit 1 }
    }
EOF

    CHECK_RESULT $? 0 0 "FunctionNetwork_003 fail"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    clean_dsoftbus FunctionNetwork_003

    LOG_INFO "End to restore the test environment."
}

main "$@"
