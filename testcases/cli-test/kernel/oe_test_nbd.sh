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

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if grep nbd /lib/modules/"$(uname -r)"/modules.builtin; then
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
    while true; do
        rmmod -f nbd
        lsmod | grep ^nbd
        local rv=$?
        [[ "$rv"x != "0x" ]] && break
        [ $trr -ge 20 ] && CHECK_RESULT $rv 1 0 "Module not uninstalled"
        sleep 0.1s
        ((trr++))
    done
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    rmmod -f nbd
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"
