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

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "kata-containers qemu-system-${NODE1_FRAME} virtiofsd runc"
    # 定义全局临时文件
    export TMP_CFG="/tmp/kata-test.toml"
    export TMP_LOG="/tmp/kata-log.out"
    export TMP_ROOT_DIR="/tmp/kata-state-dir"
    mkdir -p "${TMP_ROOT_DIR}"
    # 生成最小可用kata配置
     cat > "${TMP_CFG}" << EOF
[runtime]
debug = true
trace = true

[hypervisor.qemu]
shared_fs = "virtio-9p"
path = "/usr/bin/qemu-system-${NODE1_FRAME}"
machine_type = "pc"
kernel = "/var/lib/kata/kernel"
initrd = "/var/lib/kata/kata-containers-initrd.img"
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    kata-runtime --help 2>/dev/null | grep "kata-runtime"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: kata-runtime --help"
    kata-runtime --version 2>/dev/null | grep "$(rpm -qa kata-containers | awk -F'-' '{print $3}')"
    CHECK_RESULT $? 0 0 "kata-runtime --version failed"
    kata-runtime --show-default-config-paths 2>/dev/null | grep "/etc/kata-containers"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: kata-runtime --show-default-config-paths"
    # --kata-config
    kata-runtime --kata-config "${TMP_CFG}" version 2>/dev/null | grep "kata-runtime"
    CHECK_RESULT $? 0 0 "kata-runtime --kata-config failed"
    rm -f "${TMP_LOG}"
    kata-runtime --kata-config "${TMP_CFG}" --log "${TMP_LOG}" kata-env >/dev/null 2>&1; grep "kernel property found" "${TMP_LOG}"
    CHECK_RESULT $? 0 0 "kata-runtime --log failed"
    # text 默认格式
    kata-runtime --kata-config "${TMP_CFG}" --log-format text kata-env 2>/dev/null | grep "kernel"
    CHECK_RESULT $? 0 0 "kata-runtime --log-format text failed"
    # json 结构化格式
    kata-runtime --kata-config /tmp/kata-test.toml --log-format json --log /tmp/kata_json.log kata-env >/dev/null 2>&1; grep "{" /tmp/kata_json.log
    CHECK_RESULT $? 0 0 "kata-runtime --log-format json failed"
    kata-runtime --kata-config /tmp/kata-test.toml kata-check 2>/dev/null | grep -q "System is capable of running Kata Containers"
    CHECK_RESULT $? 0 0 "kata-runtime kata-check failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
