#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/01/15
# @License   :   Mulan PSL v2
# @Desc      :   Test printer.target restart
# #############################################
# shellcheck disable=SC1091

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    if ! lspci | grep -i printer;then
        exit 255
        LOG_INFO "There is no printer device in this environment."
    fi
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start to run test."
    test_execution printer.target
    test_reload printer.target
    LOG_INFO "End of the test."
}

main "$@"

