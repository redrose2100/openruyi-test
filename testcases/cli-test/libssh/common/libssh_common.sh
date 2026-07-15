#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Common helpers for libssh test cases.
# #############################################

# Compile a libssh C test program and assert success.
# Usage: libssh_compile <src_path> <bin_path>
function libssh_compile() {
    local src=$1
    local bin=$2
    gcc "${src}" -o "${bin}" -lssh
    CHECK_RESULT $? 0 0 "Failed to compile ${src}"
}

# Run a compiled binary and save its stdout to a file.
# Usage: libssh_run <bin_path> <out_path>
function libssh_run() {
    local bin=$1
    local out=$2
    "${bin}" > "${out}"
}
