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
#@Desc          :   Test dsoftbus interface
#####################################
# shellcheck disable=SC1091,SC2154
source ../common/comm_lib_pair.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    pre_dsoftbus CloseSessionInterface_002

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    SSH_CMD "nohup /CloseSessionInterface_002 >/dev/null 2>&1 & " "${NODE2_IPV4}"  "${NODE2_PASSWORD}"  "${NODE2_USER}"  300 22

    expect_test
    expect << EOF
    set timeout 300
    spawn ./CloseSessionInterface_002
    expect {
      "status=online" {send "c\r"}
      timeout { exit 1 }
    }
    expect {
      "CloseSession ok" { exit 0 }
      timeout { exit 1 }
    }
    wait result
    exit [lindex $result 3]
EOF

    CHECK_RESULT $? 0 1 "CloseSessionInterface_002 fail"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    clean_dsoftbus CloseSessionInterface_002

    LOG_INFO "End to restore the test environment."
}

main "$@"
