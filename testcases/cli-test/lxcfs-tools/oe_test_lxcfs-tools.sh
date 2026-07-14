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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   System Management Tools lxcfs-tools
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lxc lxc-devel lxc-libs lxcfs lxcfs-tools tar busybox runc"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    lxcfs-tools --help | grep "lxcfs-tools"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools --help"
    lxcfs-tools --version | grep "$(rpm -qa lxcfs-tools | awk -F'-' '{print $3}')"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools --version"
    systemctl start lxcfs
    CHECK_RESULT $? 0 0 "Failed to start lxcfs service"
    systemctl status lxcfs | grep "active (running)"
    CHECK_RESULT $? 0 0 "Failed to verify lxcfs service status"
    lxcfs-tools check-lxcfs 2>&1 | grep "lxcfs is running"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools check-lxcfs"
    lxc-create -t /usr/share/lxc/templates/lxc-busybox -n test1
    CHECK_RESULT $? 0 0 "Failed to create lxc container"
    lxcfs-tools remount -all 2>&1 | grep -q "remount"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools remount"
    lxcfs-tools umount -all 2>&1 | grep -q "umount"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools umount"
    lxcfs-tools prestart 2>&1 | grep -E "(mount|bind)"
    CHECK_RESULT $? 0 0 "log message: Failed to run command: lxcfs-tools prestart"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "start environment cleanup."
    lxc-stop -n "test1" 2>/dev/null || true
    lxc-destroy -n "test1" 2>/dev/null || true
    systemctl stop lxcfs
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
