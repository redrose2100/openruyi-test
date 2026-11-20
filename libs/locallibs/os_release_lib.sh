#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Desc      :   发行版信息兼容层
# #####################################
# shellcheck disable=SC2034
#
# openEuler 系镜像会在 /etc 下额外放置 openEuler-latest、openEuler-release、
# openEuler_security 等文件，openRuyi 等衍生发行版没有这些文件，只有标准的
# /etc/os-release。用例直接读 /etc/openEuler-* 会在衍生版上直接报错失败。
#
# 本文件提供与发行版无关的统一入口：
#   OS_RELEASE_LATEST_FILE   /etc/openEuler-latest（不存在时为空）
#   OS_RELEASE_RELEASE_FILE  /etc/openEuler-release（不存在时为空）
#   OS_RELEASE_ID            发行版 ID，如 openEuler / openruyi
#   OS_RELEASE_VERSION_ID    版本号，如 24.03 / Creek
#   OS_RELEASE_PRETTY_NAME   完整名称，如 openEuler 24.03 (LTS-SP1)
#   OS_RELEASE_VERSION       openEuler 仓库风格版本串，如 openEuler-24.03-LTS-SP1
#
# 所有函数都只在显式调用时执行，source 本文件不会产生输出或副作用。

OS_RELEASE_OS_RELEASE_FILE="/etc/os-release"
if [ -f /etc/openEuler-latest ]; then
    OS_RELEASE_LATEST_FILE="/etc/openEuler-latest"
else
    OS_RELEASE_LATEST_FILE=""
fi
if [ -f /etc/openEuler-release ]; then
    OS_RELEASE_RELEASE_FILE="/etc/openEuler-release"
else
    OS_RELEASE_RELEASE_FILE=""
fi

# 读取 /etc/os-release 中指定键的值，去掉包裹的双引号。$1 为键名。
function OS_RELEASE_GET_FIELD() {
    local key=$1
    [ -r "${OS_RELEASE_OS_RELEASE_FILE}" ] || return 1
    grep -E "^${key}=" "${OS_RELEASE_OS_RELEASE_FILE}" 2>/dev/null |
        head -n 1 | cut -d= -f2- | tr -d '"'
}

function OS_RELEASE_ID() {
    local id
    id=$(OS_RELEASE_GET_FIELD ID)
    [ -n "${id}" ] || id=$(OS_RELEASE_GET_FIELD DISTRIB_ID)
    echo "${id}"
}

function OS_RELEASE_VERSION_ID() {
    local version_id
    version_id=$(OS_RELEASE_GET_FIELD VERSION_ID)
    [ -n "${version_id}" ] || version_id=$(OS_RELEASE_GET_FIELD DISTRIB_RELEASE)
    echo "${version_id}"
}

function OS_RELEASE_PRETTY_NAME() {
    local pretty
    pretty=$(OS_RELEASE_GET_FIELD PRETTY_NAME)
    [ -n "${pretty}" ] || pretty=$(OS_RELEASE_GET_FIELD DISTRIB_DESCRIPTION)
    echo "${pretty}"
}

# 归一化成 openEuler 仓库使用的版本目录名，例如：
#   "openEuler 24.03 (LTS-SP1)" -> openEuler-24.03-LTS-SP1
#   "openRuyi Creek"            -> openRuyi-Creek
# 有 /etc/openEuler-latest 时优先使用其中声明的 openeulerversion。
function OS_RELEASE_VERSION() {
    local version
    if [ -n "${OS_RELEASE_LATEST_FILE}" ]; then
        version=$(grep -E '^openeulerversion=' "${OS_RELEASE_LATEST_FILE}" 2>/dev/null |
            head -n 1 | cut -d= -f2- | tr -d '"')
        if [ -n "${version}" ]; then
            echo "${version}"
            return 0
        fi
    fi
    version=$(OS_RELEASE_PRETTY_NAME)
    if [ -z "${version}" ]; then
        version="$(OS_RELEASE_ID) $(OS_RELEASE_VERSION_ID)"
    fi
    echo "${version}" |
        sed -E 's/ ([0-9]+\.[0-9]+) \(([^)]+)\)/-\1-\2/' |
        tr -d '()' | tr ' ' '-'
}

# 把系统版本信息填充到调用方的 openeulerversion/version_info 变量。
# 兼容原先 `source /etc/openEuler-latest` 的用法：文件存在时行为完全不变，
# 文件不存在时用 os-release 推导出等价的值，避免变量为空导致后续逻辑错乱。
function OS_RELEASE_EXPORT_VERSION() {
    if [ -n "${OS_RELEASE_LATEST_FILE}" ]; then
        # shellcheck disable=SC1090
        source "${OS_RELEASE_LATEST_FILE}"
    fi
    if [ -z "${openeulerversion}" ]; then
        openeulerversion=$(OS_RELEASE_VERSION)
    fi
    if [ -z "${version_info}" ]; then
        version_info=${openeulerversion}
    fi
    export openeulerversion version_info
}

# /etc/openEuler_security/ 等目录只在 openEuler 完整发行版上存在，
# 衍生版上相关用例应跳过而不是报失败。返回 0 表示可用。
function OS_RELEASE_HAS_SECURITY_DIR() {
    [ -d /etc/openEuler_security ]
}
