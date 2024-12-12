#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test dbus-org.freedesktop.login1.service restart
# #############################################

source "$OET_PATH/testcases/cli-test/common/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    test_execution dbus-org.freedesktop.login1.service
    if [[ "$NODE1_FRAME" != "riscv64" && "$NODE1_FRAME" != "x86_64" ]]; then
        test_reload dbus-org.freedesktop.login1.service
    fi
    LOG_INFO "Finish test!"
}

main "$@"
