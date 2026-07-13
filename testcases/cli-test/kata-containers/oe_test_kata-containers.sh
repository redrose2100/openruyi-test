#!/usr/bin/bash
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
 	 
# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Verify kata package installation integrity.
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "kata-containers"
}

function run_test() {
    LOG_INFO "Start to run test."
    # 1.校验rpm包是否安装成功
    rpm -qa | grep kata-containers
    CHECK_RESULT $? 0 0 "kata-containers rpm package not installed"

    # 2.校验包内文件无损坏、无缺失
    rpm -V kata-containers
    CHECK_RESULT $? 0 0 "kata-containers package file damaged or missing"

    # 3.校验软件包基础信息正常读取
    rpm -qi kata-containers
    CHECK_RESULT $? 0 0 "Failed to read kata-containers package info"

    # 4.校验核心二进制文件存在
    test -f /usr/bin/kata-runtime
    CHECK_RESULT $? 0 0 "kata-runtime binary missing"
    test -f /usr/bin/kata-monitor
    CHECK_RESULT $? 0 0 "kata-monitor binary missing"
    test -f /usr/bin/containerd-shim-kata-v2
    CHECK_RESULT $? 0 0 "containerd-shim-kata-v2 binary missing"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
}

main "$@"
