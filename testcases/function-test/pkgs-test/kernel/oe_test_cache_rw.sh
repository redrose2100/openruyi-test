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
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test 缓存读写
# #############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

# 直接读 /proc/meminfo 取缓存大小（单位 KB），避免依赖 procps-ng 提供的 free。
function get_cache_size() {
    awk '/^(Buffers|Cached):/{sum += $2} END{if (sum == "") sum = 0; print sum}' /proc/meminfo
}

function run_test() {
    LOG_INFO "Start testing..."
    cache_size=$(get_cache_size)
    CHECK_RESULT $? 0 0 "Failed to view cache information"
    test -n "${cache_size}"
    CHECK_RESULT $? 0 0 "Failed to view cache information"
    echo 3 >/proc/sys/vm/drop_caches
    CHECK_RESULT $? 0 0 "Failed to clear cache"
    cache_size=$(get_cache_size)
    dd if=/dev/zero of=/tmp/testfile count=100 bs=1M
    CHECK_RESULT $? 0 0 "fail to write to file"
    cache_size1=$(get_cache_size)
    test -n "${cache_size1}"
    CHECK_RESULT $? 0 0 "Failed to view cache information"
    [ "${cache_size1:-0}" -gt "${cache_size:-0}" ]
    CHECK_RESULT $? 0 0 "Cache utilization not increasing"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    echo 3 >/proc/sys/vm/drop_caches
    rm -rf /tmp/testfile
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"
