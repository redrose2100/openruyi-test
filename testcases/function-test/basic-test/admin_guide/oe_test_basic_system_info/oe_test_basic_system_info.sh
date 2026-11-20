#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.04-28
# @License   :   Mulan PSL v2
# @Desc      :   View system information
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/libs/locallibs/os_release_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    # 发行版名称/版本一律从 /etc/os-release 运行时读取，不写死 openEuler
    OS_NAME=$(OS_RELEASE_GET_FIELD NAME)
    OS_ID=$(OS_RELEASE_GET_FIELD ID)
    OS_VERSION_ID=$(OS_RELEASE_VERSION_ID)
    OS_PRETTY_NAME=$(OS_RELEASE_PRETTY_NAME)
    for f in "${OS_NAME}" "${OS_ID}" "${OS_VERSION_ID}" "${OS_PRETTY_NAME}"; do
        test -n "$f"
        CHECK_RESULT $?
    done
    grep "^NAME=\"${OS_NAME}\"" /etc/os-release
    CHECK_RESULT $?
    grep "^ID=\"${OS_ID}\"" /etc/os-release
    CHECK_RESULT $?
    grep "^VERSION_ID=\"${OS_VERSION_ID}\"" /etc/os-release
    CHECK_RESULT $?
    grep "^PRETTY_NAME=\"${OS_PRETTY_NAME}\"" /etc/os-release
    CHECK_RESULT $?
    # ANSI_COLOR 是 openEuler 专有字段，衍生发行版可缺失，存在时才校验格式
    if grep -q '^ANSI_COLOR=' /etc/os-release; then
        grep -E '^ANSI_COLOR="[0-9;]+"' /etc/os-release
        CHECK_RESULT $?
    fi
    LOG_INFO "End of testcase execution!"
}

main "$@"
