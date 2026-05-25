#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2026/05/11
# @License   :   Mulan PSL v2
# @Desc      :   test e2freefrag
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 全局变量
TEST_DIR=""
TEST_IMG=""
LOOP_DEV=""
MOUNT_POINT=""

function pre_test() {
    LOG_INFO "Start environmental preparation."
    
    DNF_INSTALL "e2fsprogs"
    
    # 创建测试目录
    TEST_DIR="/tmp/e2freefrag_test"
    TEST_IMG="${TEST_DIR}/test_disk.img"
    MOUNT_POINT="${TEST_DIR}/mount"
    
    mkdir -p "${TEST_DIR}"
    cd "${TEST_DIR}" || {
        LOG_ERROR "Failed to change directory to ${TEST_DIR}"
        exit 1
    }
    
    # 创建虚拟磁盘（200MB，便于观察碎片化）
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=200 &>/dev/null
    
    # 格式化为 ext4
    mkfs.ext4 -F "${TEST_IMG}" &>/dev/null
    
    # 创建 loop 设备并挂载
    LOOP_DEV=$(losetup -f)
    losetup "${LOOP_DEV}" "${TEST_IMG}"
    
    mkdir -p "${MOUNT_POINT}"
    mount "${LOOP_DEV}" "${MOUNT_POINT}"
    
    # 创建一些文件来产生碎片化
    cd "${MOUNT_POINT}" || exit 1
    
    # 创建多个小文件
    for i in $(seq 1 100); do
        dd if=/dev/urandom of="small_file_${i}.txt" bs=1K count=1 &>/dev/null
    done
    
    # 创建一些大文件
    for i in $(seq 1 10); do
        dd if=/dev/urandom of="large_file_${i}.bin" bs=1M count=5 &>/dev/null
    done
    
    # 删除部分文件产生碎片
    for i in $(seq 1 50); do
        rm -f "small_file_${i}.txt"
    done
    
    for i in $(seq 1 5); do
        rm -f "large_file_${i}.bin"
    done
    
    # 再写入一些新文件（产生碎片）
    for i in $(seq 1 50); do
        dd if=/dev/urandom of="new_file_${i}.log" bs=1K count=2 &>/dev/null
    done
    
    sync
    cd "${TEST_DIR}" || exit 1
    umount "${MOUNT_POINT}"
    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 步骤1：测试 e2freefrag 基本使用（查看碎片化情况）
    LOG_INFO "Step 1: Test e2freefrag basic usage"
    e2freefrag "${TEST_IMG}" 2>/dev/null | grep -qi "Device"
    CHECK_RESULT $? 0 0 "e2freefrag basic command failed"
    
    # 获取文件系统信息并输出
    e2freefrag "${TEST_IMG}" 2>/dev/null | head -20
    CHECK_RESULT $? 0 0 "e2freefrag failed to display fragmentation info"

    # 步骤2：测试 e2freefrag 指定块大小（-c 选项）
    LOG_INFO "Step 2: Test e2freefrag with chunksize option"
    e2freefrag -c 4096 "${TEST_IMG}" 2>/dev/null | grep -qi "chunksize"
    CHECK_RESULT $? 0 0 "e2freefrag -c option failed"
    
    # 验证 -c 参数生效
    e2freefrag -c 4096 "${TEST_IMG}" 2>/dev/null | grep -q "Extent Size Range"
    CHECK_RESULT $? 0 0 "e2freefrag -c option output verification failed"

    # 步骤3：测试不同块大小参数
    LOG_INFO "Step 3: Test e2freefrag with different chunksize values"
    
    # 测试常见块大小
    for chunksize in 1024 2048 4096 8192 16384 32768; do
        LOG_INFO "Testing chunksize: ${chunksize} KB"
        e2freefrag -c "${chunksize}" "${TEST_IMG}" 2>/dev/null > "/tmp/e2freefrag_${chunksize}.log"
        CHECK_RESULT $? 0 0 "e2freefrag -c ${chunksize} failed"
        
        # 验证输出包含块大小信息
        grep -q "${chunksize}" "/tmp/e2freefrag_${chunksize}.log" 2>/dev/null
        CHECK_RESULT $? 0 0 "e2freefrag -c ${chunksize} output missing chunksize"
    done
    
    # 步骤4：测试帮助信息
    LOG_INFO "Step 4: Test e2freefrag help information"
    e2freefrag -h 2>&1 | grep -qi "usage"
    CHECK_RESULT $? 0 0 "e2freefrag help information missing"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    
    # 卸载挂载点
    mount | grep -q "${MOUNT_POINT}" && umount "${MOUNT_POINT}" 2>/dev/null
    
    # 清理 loop 设备
    if [ -n "${LOOP_DEV}" ] && losetup "${LOOP_DEV}" &>/dev/null; then
        losetup -d "${LOOP_DEV}"
    fi
    
    # 删除测试目录
    rm -rf "${TEST_DIR}"
    
    # 清理临时文件
    rm -rf /tmp/e2freefrag_*.log
    
    # 卸载 e2fsprogs
    DNF_REMOVE
    
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

