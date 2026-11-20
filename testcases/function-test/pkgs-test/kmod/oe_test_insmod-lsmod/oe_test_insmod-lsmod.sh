#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2020/10/29
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of insmod and lsmod command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    insmod -h | grep -E "Usage:|insmod \[options\]"
    CHECK_RESULT $?
    insmod -V | grep "kmod version"
    CHECK_RESULT $?
    raid0Path=/usr/lib/modules/$(uname -r)/kernel/drivers/md/raid0.ko.xz
    faultyPath=/usr/lib/modules/$(uname -r)/kernel/drivers/md/faulty.ko.xz
    SLEEP_WAIT 5 "lsmod | grep raid0 && modprobe -r raid0" 2
    CHECK_RESULT $?
    SLEEP_WAIT 5 "lsmod | grep faulty && modprobe -r faulty" 2
    CHECK_RESULT $?
    # kmod 34.x 的 insmod 没有 -p（probe）选项，模块文件也不一定是 .xz，
    # 因此改为按 modinfo 解析出的真实路径用 insmod 加载，并用 lsmod 校验。
    raid0Path=$(modinfo -n raid0 2>/dev/null)
    if [ -n "$raid0Path" ] && [ -f "$raid0Path" ]; then
        insmod "$raid0Path"
        CHECK_RESULT $? 0 0 "insmod raid0 failed"
        lsmod | grep raid0
        CHECK_RESULT $? 0 0 "raid0 is not listed by lsmod"
        modprobe -r raid0
        CHECK_RESULT $? 0 0 "modprobe -r raid0 failed"
    else
        LOG_WARN "raid0 module file is not provided by the running kernel, skip it."
    fi
    faultyPath=$(modinfo -n faulty 2>/dev/null)
    if [ -n "$faultyPath" ] && [ -f "$faultyPath" ]; then
        insmod "$faultyPath"
        CHECK_RESULT $? 0 0 "insmod faulty failed"
        lsmod | grep faulty
        CHECK_RESULT $? 0 0 "faulty is not listed by lsmod"
        modprobe -r faulty 2>/dev/null
    else
        LOG_WARN "faulty module is not provided by the running kernel, skip it."
    fi
    LOG_INFO "End of the test."
}

main "$@"
