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
    mkfs.hfsplus -N /dev/vdb1 | grep 'HFS Plus format parameter'
    CHECK_RESULT $? 0 0 "Failed option: -N"
    mkfs.hfsplus -N -J 4056K /dev/vdb1 | grep 'journal-size: 4056k'
    CHECK_RESULT $? 0 0 "Failed option: -J"
    mkfs.hfsplus -N -D journal-dev /dev/vdb1 | grep 'HFS Plus format parameters'
    CHECK_RESULT $? 0 0 "Failed option: -D"
    mkfs.hfsplus -N -G 1000 /dev/vdb1 | grep 'group ID: 1000'
    CHECK_RESULT $? 0 0 "Failed option: -G"
    mkfs.hfsplus -N -U 1000 /dev/vdb1 | grep 'user ID: 1000'
    CHECK_RESULT $? 0 0 "Failed option: -U"
    mkfs.hfsplus -N -M 755 /dev/vdb1 | grep 'access mask: 755'
    CHECK_RESULT $? 0 0 "Failed option: -M"
    mkfs.hfsplus -N -b 8192 /dev/vdb1 | grep 'block-size: 8192'
    CHECK_RESULT $? 0 0 "Failed option: -b"
    mkfs.hfsplus -N -c b=4096 /dev/vdb1 | grep '4096 blocks'
    CHECK_RESULT $? 0 0 "Failed option: -c"
    mkfs.hfsplus -N -i 17 /dev/vdb1 | grep 'first free catalog node id: 17'
    CHECK_RESULT $? 0 0 "Failed option: -i"
    mkfs.hfsplus -N -n a=4096 /dev/vdb1 | grep 'catalog b-tree node size: 8192'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    mkfs.hfsplus -N -v ascii /dev/vdb1 | grep 'ascii'
    CHECK_RESULT $? 0 0 "Failed option: -v"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
