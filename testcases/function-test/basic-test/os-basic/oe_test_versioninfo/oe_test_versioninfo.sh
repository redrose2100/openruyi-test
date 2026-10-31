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
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-29
# @License   :   Mulan PSL v2
# @Desc      :   Query system version info test
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
# 发行版信息兼容层：openRuyi 等衍生发行版没有 /etc/openEuler-release。
source ${OET_PATH}/libs/locallibs/os_release_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    if [ -f /etc/openEuler-release ]; then
        OS_VERSION=$(awk '{print$3}' /etc/openEuler-release)
        grep -w "VERSION" /etc/os-release | awk -F '"' '{print$2}' | grep -w "${OS_VERSION}"
        CHECK_RESULT $?
        grep -E "VERSION_ID" /etc/os-release | grep "$OS_VERSION"
        CHECK_RESULT $?
    else
        OS_VERSION=$(OS_RELEASE_VERSION_ID)
        [ -n "${OS_VERSION}" ]
        CHECK_RESULT $? 0 0 "Failed to get VERSION_ID from /etc/os-release"
        # 部分发行版的 os-release 没有 VERSION 字段，此时只校验 VERSION_ID，避免误判失败。
        if grep -qE "^VERSION=" /etc/os-release; then
            grep -E "^VERSION=" /etc/os-release | awk -F '"' '{print$2}' | grep -qw "${OS_VERSION}"
            CHECK_RESULT $?
        else
            LOG_INFO "/etc/os-release has no VERSION field, skipped."
        fi
        grep -E "^VERSION_ID=" /etc/os-release | grep -qw "${OS_VERSION}"
        CHECK_RESULT $?
    fi
    # NAME/ID/PRETTY_NAME 不再硬编码 openEuler，改为校验与 /etc/os-release 自洽。
    DISTRO_ID=$(OS_RELEASE_ID)
    PRETTY_NAME=$(OS_RELEASE_PRETTY_NAME)
    [ -n "${DISTRO_ID}" ]
    CHECK_RESULT $? 0 0 "Failed to get the distro ID from /etc/os-release"
    # ID 通常为小写（openruyi），NAME 可能为混合大小写（openRuyi），故忽略大小写。
    grep -E "NAME" /etc/os-release | grep -qiF "${DISTRO_ID}"
    CHECK_RESULT $?
    grep -E "^ID" /etc/os-release | grep -qiF "${DISTRO_ID}"
    CHECK_RESULT $?
    grep -E "PRETTY_NAME" /etc/os-release | grep -qF "${PRETTY_NAME}"
    CHECK_RESULT $?
    grep -E "ANSI_COLOR" /etc/os-release | grep "0;31"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

main "$@"
