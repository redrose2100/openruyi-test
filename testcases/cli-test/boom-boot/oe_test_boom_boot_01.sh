#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   jiangchenyang
#@Contact   :   jiangcy1129@163.com
#@Date      :   2023/9/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "boom-boot" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "boom-boot"
    touch boom.conf
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_boom_boot_01."
    boom -h | grep "usage: boom"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    boom -help | grep "usage: boom"
    CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
    boom -b 1 entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
    boom --boot-id 1 entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --boot-id No Pass"
    boom --bootid 1 entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --bootid No Pass"
    boom --boot-dir /boot/ profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --boot-dir No Pass"
    boom -B /path/to/btrfs/subvolume entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
    boom --btrfs-subvolume /path/to/btrfs/subvolume entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-subvolume No Pass"
    boom --btrfssubvolume /path/to/btrfs/subvolume entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfssubvolume No Pass"
    boom --btrfs-opts "boom-opts" profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-opts No Pass"
    boom --btrfsopts "boom-opts" profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfsopts No Pass"
    boom -c ./ profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    boom --config ./ profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --config No Pass"
    boom --debug "profile" profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --debug  No Pass"
    boom -H profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -H No Pass"
    boom -L /dev/openeuler/root entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
    boom --root-lv /dev/openeuler/root entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --root-lv No Pass"
    boom --rootlv /dev/openeuler/root entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --rootlv No Pass"
    boom --lvm-opts "profile" profile show
    CHECK_RESULT $? 0 0 "L$LINENO:  --lvm-opts No Pass"
    boom --lvmopts "profile" profile show
    CHECK_RESULT $? 0 0 "L$LINENO:  --lvmopts No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf boom.*
    LOG_INFO "End to restore the test environment."
}
main "$@"

