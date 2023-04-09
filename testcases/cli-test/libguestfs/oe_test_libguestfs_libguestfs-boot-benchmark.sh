#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2023/03/02
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs libguestfs-boot-benchmark command
# ############################################

source ${OET_PATH}/testcases/cli-test/libguestfs/common/common_libguestfs.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    libguestfs_pre_test
    export LIBGUESTFS_BACKEND=direct
    export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    libguestfs-boot-benchmark --help 2>&1 | grep 'boot-benchmark: Benchmark'
    CHECK_RESULT $? 0 0 "Check libguestfs-boot-benchmark  --help failed"
    libguestfs-boot-benchmark --append cat
    CHECK_RESULT $? 0 0 "Check libguestfs-boot-benchmark  --append failed"
    libguestfs-boot-benchmark -m 1024
    CHECK_RESULT $? 0 0 "Check libguestfs-boot-benchmark  -m failed"
    libguestfs-boot-benchmark --smp 1
    CHECK_RESULT $? 0 0 "Check libguestfs-boot-benchmark  --smp failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    libguestfs_post_test
    kill -9 $(pgrep -f "virt")
    LOG_INFO "Finish to restore the test environment."
}

main $@
