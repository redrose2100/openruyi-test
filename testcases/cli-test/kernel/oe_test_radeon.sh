#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024/05/24
# @License   :   Mulan PSL v2
# @Desc      :   Kernel radeon testing
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/gpu/drm/radeon/radeon.ko
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo ceph |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe radeon
    CHECK_RESULT $? 0 0 "radeon not loaded"
    lsmod | grep radeon
    CHECK_RESULT $? 0 0 "radeon loaded failed"
    rmmod radeon
    CHECK_RESULT $? 0 0 "radeon uninstall failed"
    lsmod | grep radeon
    CHECK_RESULT $? 1 0  "Module loaded"
    dmesg |grep radeon
    CHECK_RESULT $? 0 0 "Failed to detect information"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rmmod rademon
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
