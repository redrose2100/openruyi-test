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
# @Desc      :   sysmonitor 磁盘inode监控测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod/common.sh"

dir='/home/mnt/mpoint1'
fn_mount_100_disk "${dir}"
INODE_ALARM_INFO="report disk inode alarm"
INODE_RESUME_INFO="report disk inode recovered"
DISK_ALARM_INFO="report disk alarm"
DISK_RESUME_INFO="report disk recovered"

inode_cur_usage=$(df -i "${dir}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
inode_alarm=$((inode_cur_usage + 5))
inode_resume=$((inode_cur_usage + 2))
disk_usage=$(df "${dir}" | awk 'NR==2{print $5}' | awk -F % '{print $1}')
disk_alarm=$((disk_usage + 5))
disk_resume=$((disk_usage + 2))

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    DNF_INSTALL "diffutils"

    cp "${INODE_CONFIG}" "${INODE_CONFIG}.bak"
    echo "DISK=\"${dir}\" ALARM=\"${inode_alarm}\" RESUME=\"${inode_resume}\"" >> "${INODE_CONFIG}"
    diff --color "${INODE_CONFIG}.bak" "${INODE_CONFIG}"

    cp "${DISK_CONFIG}" "${DISK_CONFIG}.bak"
    echo "DISK=\"${dir}\" ALARM=\"${disk_alarm}\" RESUME=\"${disk_resume}\"" >> "${DISK_CONFIG}"
    diff --color "${DISK_CONFIG}.bak" "${DISK_CONFIG}"

    cp "${sysmonitor_conf:-}" "${sysmonitor_conf}.bak"
    sed -i "/^INODE_MONITOR_PERIOD=/ s/=.*/=\"2\"/" "${sysmonitor_conf:-}"
    sed -i "/^DISK_ALARM=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    sed -i "/^INODE_ALARM=/ s/=.*/=\"on\"/" "${sysmonitor_conf}"
    diff --color "${sysmonitor_conf}.bak" "$sysmonitor_conf"
    monitor_restart
}

# 测试点的执行
function run_test() {
    grep -w "DISK=\"${dir}\"" "${INODE_CONFIG}" \
        || add_failure "INODE_CONFIG check [$dir] failed"
    # 1 alarm
    fn_make_inode_alarm "${dir}" "${inode_alarm}"
    fn_make_disk_alarm "${dir}" "${disk_alarm}"
    # alarm: monitor log check
    fn_wait_for_monitor_log_print "${INODE_ALARM_INFO}" || oe_err "[monitor] INODE_ALARM_INFO check failed"
    fn_wait_for_monitor_log_print "${DISK_ALARM_INFO}" 5 && oe_err "[monitor] DISK_ALARM_INFO check failed"

    # 2 resume
    rm -rf "${dir}"/tmp_inode
    rm -rf "${dir}"/tmpfile_*
    # resume: monitor_log check
    fn_wait_for_monitor_log_print "${INODE_RESUME_INFO}" || oe_err "[monitor] INODE_RESUME_INFO check failed"
    fn_wait_for_monitor_log_print "${DISK_RESUME_INFO}" || oe_err "[monitor] DISK_RESUME_INFO check failed"
}

# 后置处理，恢复测试环境
function post_test() {
    grep "$dir" "${sysmonitor_log:-}"
    fn_clean_inode_to_zero "${dir}"
    fn_clean_disk_to_zero "${dir}"

    mv "${INODE_CONFIG}.bak" "${INODE_CONFIG}"
    mv "${DISK_CONFIG}.bak" "${DISK_CONFIG}"
    mv "${sysmonitor_conf}.bak" "$sysmonitor_conf"
    monitor_restart
}

main "$@"
