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
# @Desc      :   Test fsck.hfs
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL hfsplus-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    fsck.hfs -d -p -f /dev/vdb1 2>&1 | grep 'starting'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -f"
    fsck.hfs -d -p /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -p"
    fsck.hfs -d -l /dev/vdb1 2>&1 | grep '/dev/vdb1: fsck_hfs run at'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -l"
    fsck.hfs -d -m 01777 /dev/vdb1 2>&1 | grep 'Using cacheBlockSize'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -m"
    fsck.hfs -d -n /dev/vdb1 2>&1 | grep '/dev/vdb1'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -n"
    fsck.hfs -d -r /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -r"
    fsck.hfs -d -y /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -y"
    fsck.hfs -d -c 512m  /dev/vdb1 | grep 'cacheSize=524288K'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -c"
    fsck.hfs -d -c 512m  /dev/vdb1 | grep 'Using '
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -d"
    fsck.hfs -g  /dev/vdb1 | grep 'fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -g"
    fsck.hfs -d -q /dev/vdb1 | grep -v '/.*'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfs -q"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
