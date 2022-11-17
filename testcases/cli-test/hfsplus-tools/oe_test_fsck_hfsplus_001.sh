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
    fsck.hfsplus -u 2>&1 |grep 'usage: fsck.hfsplus'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -u"
    fsck.hfsplus -v 2>&1 | grep 'version'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -v"
    fsck.hfsplus -d -b 4096 /dev/vdb1 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -b"
    fsck.hfsplus -d -B /  /dev/vdb1 | grep 'blocks to match'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -B"
    fsck.hfsplus -d -c 512m  /dev/vdb1 | grep 'cacheSize=524288K'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -c"
    fsck.hfsplus -d -c 512m  /dev/vdb1 | grep 'Using '
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -d"
    fsck.hfsplus -g  /dev/vdb1 | grep 'fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -g"
    fsck.hfsplus -x  /dev/vdb1 | grep '<string>540.1-Linux</string>'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -x"
    fsck.hfsplus -d -q /dev/vdb1 | grep -v '/.*'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -q"
    fsck.hfsplus -d -E /dev/vdb1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "Failed option: fsck.hfsplus -E"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
