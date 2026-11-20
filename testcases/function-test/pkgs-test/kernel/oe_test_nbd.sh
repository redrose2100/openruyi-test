#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/05/22
# @License   :   Mulan PSL v2
# @Desc      :   Test 驱动加载_nbd
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# 卸载循环的最多尝试次数，避免 rmmod 失败时无限循环导致整个测试套超时。
MAX_RETRY=20

# 判定 nbd 是否为可加载模块：modinfo 给出 .ko 路径才是模块。
function nbd_is_module() {
    local filename
    filename=$(modinfo -F filename nbd 2>/dev/null)
    [ -n "${filename}" ] && [[ "${filename}" == *.ko* ]]
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! nbd_is_module; then
        LOG_WARN "nbd is builtin, skipping module load/unload steps"
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    modinfo nbd |grep name
    CHECK_RESULT $? 0 0 "Failed to view module information"
    modprobe nbd
    lsmod | grep ^nbd
    CHECK_RESULT $? 0 0 "Module not loaded"
    local trr=1
    while [ ${trr} -le ${MAX_RETRY} ]; do
        rmmod -f nbd
        if ! lsmod | grep ^nbd; then
            break
        fi
        sleep 0.1s
        ((trr++))
    done
    # 循环结束后再做一次终态判定，不依赖循环内部变量的残留值。
    lsmod | grep ^nbd
    CHECK_RESULT $? 1 0 "Module not uninstalled"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    if lsmod | grep ^nbd; then
        rmmod -f nbd
    fi
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"
