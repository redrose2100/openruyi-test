#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/05/30
# @License   :   Mulan PSL v2
# @Desc      :   Test soft-reboot.target restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "A special target unit for shutting down and rebooting the system."
    test_oneshot soft-reboot.target 'inactive (dead)'
    LOG_INFO "End of the test."
}

main "$@"
