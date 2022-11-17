#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2022/10/18
# @License   :   Mulan PSL v2
# @Desc      :   Test fsck.hfsplus
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL hfsplus-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    fsck.hfsplus -d -p -f /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -f"
    fsck.hfsplus -d -p /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -p"
    fsck.hfsplus -d -l /dev/shm 2>&1 | grep 'run at'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -l"
    fsck.hfsplus -d -m 01777 /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -m"
    fsck.hfsplus -d -n /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -n"
    fsck.hfsplus -d -r /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -r"
    fsck.hfsplus -d -y /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -y"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
