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

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "kata-containers qemu-kvm"

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    kata-runtime --help 2>/dev/null | grep "kata-runtime"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: kata-runtime --help"

    kata-runtime --version 2>/dev/null | grep -E -o "kata-runtime[[:space:]]+:[[:space:]]+[0-9.]{1,}"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: kata-runtime --version"

    kata-runtime --show-default-config-paths 2>/dev/null | grep "/etc/kata-containers"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: kata-runtime --show-default-config-paths"

    test -f /usr/bin/kata-runtime
    CHECK_RESULT $? 0 0 "kata-runtime binary missing"

    test -f /usr/bin/kata-monitor
    CHECK_RESULT $? 0 0 "kata-monitor binary missing"

    test -f /usr/bin/containerd-shim-kata-v2
    CHECK_RESULT $? 0 0 "containerd-shim-kata-v2 binary missing"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
