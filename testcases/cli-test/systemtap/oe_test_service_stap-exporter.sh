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
# @Desc      :   Test stap-exporter.service restart
#April's remind :   If stap-exporter skipped, please check whether debuginfo is enabled in the repo.
# #############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"


function pre_test() {
    LOG_INFO "Start environmental preparation."
    current_kernel=$(uname -r)
    DNF_INSTALL "systemtap-stap-exporter systemtap-client systemtap-devel gcc kernel-devel-${current_kernel} kernel-debuginfo-${current_kernel} kernel-headers-${current_kernel}"
    # 检查 kernel-devel kernel-debuginfo kernel-headers 是否安装,缺少任何一个则通不过编译
    if ! rpm -q "kernel-devel-${current_kernel}" &>/dev/null; then
        LOG_WARN "kernel-devel-${current_kernel} is not installed."
        exit 255
    fi
    if ! rpm -q "kernel-debuginfo-${current_kernel}" &>/dev/null; then
        LOG_WARN "kernel-debuginfo-${current_kernel} is not installed."
        exit 255
    fi
    if ! rpm -q "kernel-headers-${current_kernel}" &>/dev/null; then
        LOG_WARN "kernel-headers-${current_kernel} is not installed."
        exit 255
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution stap-exporter.service
    test_reload stap-exporter.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop stap-exporter.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
