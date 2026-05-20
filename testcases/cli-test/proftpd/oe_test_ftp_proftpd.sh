#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-05-20
# @License   :   Mulan PSL v2
# @Desc      :   proftpd service test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "proftpd"
    LOG_INFO "End of environmental preparation!"
}

function run_test()
{
    LOG_INFO "start to run test."

    # 启动服务
    systemctl start proftpd
    CHECK_RESULT $? 0 0 "start proftpd failed"

    # 等待端口启动
    sleep 2

    # 检测21端口是否监听
    ss -tuln | grep -q ":21"
    CHECK_RESULT $? 0 0 "proftpd port 21 not listening"

    LOG_INFO "All test executed successfully!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    systemctl stop proftpd
    #shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"