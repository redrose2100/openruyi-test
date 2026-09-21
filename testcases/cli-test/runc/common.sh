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
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-22
# @License   :   Mulan PSL v2
# @Desc      :   runc test common functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function prepare_rootfs() {
    local bundle_path=$1
    
    mkdir -p "$bundle_path/rootfs/bin"
    mkdir -p "$bundle_path/rootfs/lib"
    mkdir -p "$bundle_path/rootfs/lib64"
    mkdir -p "$bundle_path/rootfs/usr/lib64"
    cp -a /bin/sleep "$bundle_path/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/echo "$bundle_path/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/sh "$bundle_path/rootfs/bin/" 2>/dev/null || true
    cp -a /bin/cat "$bundle_path/rootfs/bin/" 2>/dev/null || true
    if [ $(uname -m) != "riscv64" ]; then
        cp -a /lib/ld-linux-aarch64.so.1 "$bundle_path/rootfs/lib/" 2>/dev/null || true
        cp -a /lib/ld-linux-x86-64.so.2 "$bundle_path/rootfs/lib/" 2>/dev/null || true
        cp -a /lib64/ld-linux-x86-64.so.2 "$bundle_path/rootfs/lib64/" 2>/dev/null || true
        cp -a /usr/lib64/libc.so.6 "$bundle_path/rootfs/usr/lib64" 2>/dev/null || true
        cp -a /usr/lib64/libc.so.6 "$bundle_path/rootfs/lib64" 2>/dev/null || true
    else
        mkdir -p "$bundle_path/rootfs/usr/lib64/lp64d"
        mkdir -p "$bundle_path/rootfs/lib64/lp64d"
        cp -a /lib/ld-linux-riscv64-lp64d.so.1 "$bundle_path/rootfs/lib/" 2>/dev/null || true
        cp -a /usr/lib64/libc.so.6 "$bundle_path/rootfs/usr/lib64/lp64d/" 2>/dev/null || true
        cp -a /usr/lib64/libc.so.6 "$bundle_path/rootfs/lib64/lp64d/" 2>/dev/null || true
    fi
    cd "$bundle_path" || exit 1
}

function cleanup_container() {
    local container_id=$1
    runc delete -f "$container_id" 2>/dev/null || true
    runc --root /tmp/custom_runc_root delete -f "$container_id" 2>/dev/null || true
}

