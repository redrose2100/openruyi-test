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
# @Author    :   zhangmei
# @Contact   :   zhangmei@uniontech.com
# @Date      :   2023/04/12
# @License   :   Mulan PSL v2
# @Desc      :   xfs模块加载、卸载
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 判定 xfs 是否为可加载模块：modinfo 能给出 .ko 路径才是模块，
# 编译进内核（builtin）时 modinfo 输出的是 fs/xfs/xfs 这类无扩展名路径。
function xfs_is_module() {
    local filename
    filename=$(modinfo -F filename xfs 2>/dev/null)
    [ -n "${filename}" ] && [[ "${filename}" == *.ko* ]]
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! xfs_is_module; then
        LOG_WARN "xfs is built into the kernel, module load/unload test is not applicable."
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    modinfo xfs |grep xfs
    CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
    lsmod | grep  xfs
    CHECK_RESULT $? 0 1 "Default uninstallation"
    modprobe xfs
    CHECK_RESULT $? 0 0 "Module start"
    lsmod | grep  xfs
    CHECK_RESULT $? 0 0 "xfs found"
    rmmod  xfs
    CHECK_RESULT $? 0 0 "xfs remove failure"
    lsmod | grep  xfs
    CHECK_RESULT $? 0 1 "xfs stop"
    dmesg | grep "xfs" | grep -Ei 'error|fail'
    CHECK_RESULT $? 1 0 "error message was reported"
}

main "$@"
