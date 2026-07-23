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
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Verify kata-containers VM create、start and isolation
# ############################################

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    CONTAINER_ID="test-kata-vm-$(date +%s)"
    BUNDLE_DIR="/tmp/kata-bundle-${CONTAINER_ID}"
    SYS_CFG="/usr/share/defaults/kata-containers/configuration.toml"

    # 容错：文件存在才备份，不存在不中断流程
    [ -f "${SYS_CFG}" ] && cp "${SYS_CFG}" "${SYS_CFG}.bak"

    # 安装全套依赖
    DNF_INSTALL "kata-containers runc qemu-system-${NODE1_FRAME} virtiofsd"

    # 构建rootfs目录并拷贝基础命令与库
    mkdir -p "${BUNDLE_DIR}/rootfs"/{bin,lib64,dev,proc,sys}
    cp /bin/sleep /bin/uname "${BUNDLE_DIR}/rootfs/bin/"
    cp /lib64/ld-linux*.so.* "${BUNDLE_DIR}/rootfs/lib64/"

    # 生成oci config.json
    cat > "${BUNDLE_DIR}/config.json" << EOF
{
    "ociVersion": "1.0.0",
    "process": {"args": ["sleep", "10"], "cwd": "/", "terminal": false},
    "root": {"path": "rootfs"},
    "hostname": "kata-test",
    "mounts": [{"destination": "/proc", "type": "proc", "source": "proc"}]
}
EOF

    # 覆盖系统默认kata配置，全部使用本机真实文件路径
    cat > "${SYS_CFG}" << EOF

[hypervisor.qemu]
shared_fs = "virtio-9p"
path = "/usr/bin/qemu-system-${NODE1_FRAME}"
machine_type = "pc"
kernel = "/var/lib/kata/kernel"
initrd = "/var/lib/kata/kata-containers-initrd.img"

EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    CONTAINER_ID="test-kata-vm-$(date +%s)"
    BUNDLE_DIR="/tmp/kata-bundle-${CONTAINER_ID}"

    kata-runtime create "${CONTAINER_ID}" --bundle "${BUNDLE_DIR}"
    CHECK_RESULT $? 0 0 "create failed"

    kata-runtime start "${CONTAINER_ID}"
    kata-runtime state "${CONTAINER_ID}" | grep running
    CHECK_RESULT $? 0 0 "Sandbox not running"

    kata-runtime exec "${CONTAINER_ID}" uname -r | grep -E "[0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "Cannot enter guest VM"

    kata-runtime kill "${CONTAINER_ID}"
    sleep 1
    kata-runtime state "${CONTAINER_ID}" | grep stopped
    CHECK_RESULT $? 0 0 "Sandbox stop failed"

    kata-runtime delete "${CONTAINER_ID}"
    kata-runtime list | grep -v "${CONTAINER_ID}"
    CHECK_RESULT $? 0 0 "Delete sandbox failed"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    CONTAINER_ID="test-kata-vm-$(date +%s)"
    BUNDLE_DIR="/tmp/kata-bundle-${CONTAINER_ID}"
    SYS_CFG="/usr/share/defaults/kata-containers/configuration.toml"

    # 备份文件存在才恢复原配置，避免mv报错
    [ -f "${SYS_CFG}.bak" ] && mv -f "${SYS_CFG}.bak" "${SYS_CFG}"

    # 清理残留容器
    kata-runtime kill "${CONTAINER_ID}" 2>/dev/null || true
    kata-runtime delete "${CONTAINER_ID}" 2>/dev/null || true
    # 删除临时bundle目录
    rm -rf "${BUNDLE_DIR}"
    # 卸载测试安装的包
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
