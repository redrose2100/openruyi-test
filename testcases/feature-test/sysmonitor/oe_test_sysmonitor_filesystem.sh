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
# @Author    :   maojintao
# @Contact   :   mjt1220@126.com
# @Date      :   2023/07/26
# @License   :   Mulan PSL v2
# @Desc      :   sysmonitor 文件系统监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/feature-test/sysmonitor/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    cp -a "${sysmonitor_conf:-}" "${sysmonitor_conf}".bak
    sed -i "/^FILESYSTEM_MONITOR=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    monitor_restart
    grep -q "the kernel do not support filesystem monitor" "${sysmonitor_log}" && exit 255
}

# 测试点的执行
function run_test() {
    ext_type=mkfs.ext3
    lsmod | grep ext4 && ext_type=mkfs.ext4
    umount -l /home/mnt/mpoint
    rm -rf /home/mnt
    mkdir -p /home/mnt/mpoint
    dd if=/dev/zero of=/home/mnt/disk bs=1M count=200
    echo y | "${ext_type}" /home/mnt/disk
    mount /home/mnt/disk /home/mnt/mpoint || oe_err "mount /home/mnt/mpoint check failed"
    dd if=/dev/zero of=/home/mnt/disk bs=512 count=10
    devloop=$(df | grep /home/mnt/mpoint | awk '{print $1}')
    loop_name="${devloop:5}"
    ls /home/mnt/mpoint
    fn_wait_for_monitor_log_print "${loop_name} filesystem error" || oe_err "filesystem error check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    umount -l /home/mnt/mpoint
    rm -rf /home/mnt
    mv "${sysmonitor_conf}".bak "${sysmonitor_conf}"
    monitor_restart
}

main "$@"
