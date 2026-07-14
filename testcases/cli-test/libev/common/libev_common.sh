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
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Test libev core watcher functionality (timer, io, signal)
# #############################################
# shellcheck disable=SC2119

# Usage: libev_compile <src_path> <bin_path>
function libev_compile() {
    local src=$1
    local bin=$2
    gcc "${src}" -o "${bin}" -lev
    CHECK_RESULT $? 0 0 "Failed to compile ${src}"
}

# Usage: libev_run <bin_path> <out_path>
function libev_run() {
    local bin=$1
    local out=$2
    "${bin}" > "${out}"
}

