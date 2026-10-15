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
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/7/3
# @License   :   Mulan PSL v2
# @Desc      :   Test mdmonitor-oneshot.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"
source "./common/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mdadm
    disks=$(TEST_DISK)
    disk_list="${disks}"
    disk1=${disk_list[0]}
    disk2=${disk_list[1]}
    echo "y" | mdadm -C /dev/md0 -l1 -n2 /dev/"${disk1}" /dev/"${disk2}"
    systemctl enable mdmonitor-oneshot.timer
    systemctl start mdmonitor-oneshot.timer
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_oneshot mdmonitor-oneshot.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop mdmonitor-oneshot.timer
    systemctl stop mdmonitor-oneshot.service
    mdadm -S md0
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
