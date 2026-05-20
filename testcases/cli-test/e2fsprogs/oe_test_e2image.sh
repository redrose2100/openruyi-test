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
# @Desc      :   test e2image
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
    
    # 创建测试目录和文件
    TEST_DIR="/tmp/e2image_test"
    TEST_IMG="${TEST_DIR}/test_disk.img"
    MOUNT_POINT="${TEST_DIR}/mount"
    
    mkdir -p "${TEST_DIR}" "${MOUNT_POINT}"
    cd "${TEST_DIR}" || exit 1
    
    # 创建虚拟磁盘（100MB）
    dd if=/dev/zero of="${TEST_IMG}" bs=1M count=100 &>/dev/null
    
    # 格式化为 ext4
    mkfs.ext4 -F "${TEST_IMG}" &>/dev/null
    
    # 创建 loop 设备并挂载
    LOOP_DEV=$(losetup -f)
    losetup "${LOOP_DEV}" "${TEST_IMG}"
    mount "${LOOP_DEV}" "${MOUNT_POINT}"
    
    # 创建测试文件
    cd "${MOUNT_POINT}" || exit 1
    echo "test file content" > testfile.txt
    mkdir testdir
    echo "subdir file" > testdir/subfile.txt
    
    for i in $(seq 1 10); do
        echo "data ${i}" > "file_${i}.txt"
    done
    
    sync
    cd "${TEST_DIR}" || exit 1
    umount "${MOUNT_POINT}"
    losetup -d "${LOOP_DEV}"
    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 步骤1：测试 e2image 创建元数据镜像（标准模式）
    LOG_INFO "Step 1: Test e2image create metadata image"
    e2image "${TEST_IMG}" "${TEST_DIR}/metadata.img" 2>/dev/null
    CHECK_RESULT $? 0 0 "e2image basic mode failed"
    
    # 验证镜像文件已创建
    test -f "${TEST_DIR}/metadata.img"
    CHECK_RESULT $? 0 0 "e2image metadata image not created"
    LOG_INFO "Standard metadata image created: $(stat -c %s "${TEST_DIR}/metadata.img") bytes"

    # 步骤2：测试 e2image 创建原始元数据镜像（-r 选项）
    LOG_INFO "Step 2: Test e2image with -r option (raw metadata)"
    e2image -r "${TEST_IMG}" "${TEST_DIR}/metadata_raw.img" 2>/dev/null
    CHECK_RESULT $? 0 0 "e2image -r option failed"
    
    # 验证原始镜像文件存在
    test -f "${TEST_DIR}/metadata_raw.img"
    CHECK_RESULT $? 0 0 "e2image -r metadata image not created"
    LOG_INFO "Raw metadata image created: $(stat -c %s "${TEST_DIR}/metadata_raw.img") bytes"

    # 步骤3：测试 e2image 创建 QEMU 格式镜像（-Q 选项）
    LOG_INFO "Step 3: Test e2image with -Q option (QEMU format)"
    e2image -Q "${TEST_IMG}" "${TEST_DIR}/metadata.qcow2" 2>/dev/null
    CHECK_RESULT $? 0 0 "e2image -Q option failed"
    
    # 验证 QEMU 格式文件存在
    test -f "${TEST_DIR}/metadata.qcow2"
    CHECK_RESULT $? 0 0 "e2image QEMU format image not created"
    LOG_INFO "QEMU format image created: $(stat -c %s "${TEST_DIR}/metadata.qcow2") bytes"

    # 步骤4：测试 e2image 镜像信息查看（不测试恢复功能，因为 -I 需要特殊条件）
    LOG_INFO "Step 4: Test e2image info display"
    
    # 使用 -Q 镜像查看信息（qemu-img info 配合使用）
    if command -v qemu-img &>/dev/null; then
        qemu-img info "${TEST_DIR}/metadata.qcow2" 2>/dev/null | grep -qi "qcow2"
        CHECK_RESULT $? 0 0 "qemu-img info on e2image output failed"
        LOG_INFO "e2image QEMU format image verified with qemu-img"
    else
        LOG_WARN "qemu-img not installed, skipping QEMU format verification"
    fi
    
    # 步骤5：测试 e2image 参数错误处理
    LOG_INFO "Step 5: Test e2image error handling"
    e2image 2>&1 | grep -qi "e2image"
    CHECK_RESULT $? 0 0 "e2image error output missing"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    
    # 卸载可能还在的挂载点
    mount | grep -q "${MOUNT_POINT}" && umount "${MOUNT_POINT}" 2>/dev/null
    mount | grep -q "${TEST_DIR}/mount_restored" && umount "${TEST_DIR}/mount_restored" 2>/dev/null
    
    # 清理 loop 设备
    while IFS= read -r loop; do
        losetup -d "${loop}" 2>/dev/null
    done < <(losetup -l 2>/dev/null | grep "${TEST_DIR}" | awk '{print $1}')
    
    # 删除测试目录
    rm -rf "${TEST_DIR}"
    
    # 清理变量
    unset TEST_DIR TEST_IMG LOOP_DEV MOUNT_POINT
    
    # 卸载 e2fsprogs
    # shellcheck disable=SC2119
    DNF_REMOVE
    
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
