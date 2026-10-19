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
# @Desc      :   sysmonitor 磁盘分区监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

alarm=40
resume=30
dir=/update
ext_type=mkfs.ext3
lsmod | grep ext4 && ext_type=mkfs.ext4

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    monitor_restart
    disk_prefun
    rm -rf /home/mnt
    mkdir -p /home/mnt
    mkdir -p "$dir"
    dd if=/dev/zero of=/home/mnt/disk bs=1M count=100
    echo y | "${ext_type}" /home/mnt/disk
    mount /home/mnt/disk "$dir"

    DISK_ALARM_INFO="report disk alarm, ${dir}"
    DISK_RESUME_INFO="report disk recovered, ${dir}"

}

# 测试点的执行
function run_test() {
    # 1 mod config
    echo "DISK=\"/os2\" ALARM=\"${alarm}\" RESUME=\"${resume}\"" >> "${DISK_CONFIG}"
    echo "DISK=\"${dir}\" ALARM=\"${alarm}\" RESUME=\"${resume}\"" >> "${DISK_CONFIG}"
    mkdir -p /os2
    mount /home/mnt/disk /os2
    monitor_restart

    # 2 alarm
    pidlist=
    fn_make_disk_alarm "${dir}" "${alarm}" &
    pidlist="$pidlist $!"
    fn_make_disk_alarm /os2 "${alarm}" &
    pidlist="$pidlist $!"
    wait "$pidlist"
    echo "pidlist is ""$pidlist"

    fn_wait_for_monitor_log_print "${DISK_ALARM_INFO}" || oe_err "[monitor] alarm check failed"

    # 3 resume
    pidlist=
    fn_clean_disk_to_resume "${dir}" "${resume}" &
    pidlist="$pidlist $!"
    fn_clean_disk_to_resume /os2 "${resume}" &
    pidlist="$pidlist $!"
    wait "$pidlist"
    echo "pidlist is ""$pidlist"
    fn_wait_for_monitor_log_print "${DISK_RESUME_INFO}" || oe_err "[monitor] resume check failed"
    df ${dir}

}

# 后置处理，恢复测试环境
function post_test() {
    fn_clean_disk_to_zero "${dir}"
    umount -l "$dir"
    umount /os2
    rm -rf "$dir"
    rm -rf /home/mnt
    rm -rf /os2
    disk_postfun

}

main "$@"
