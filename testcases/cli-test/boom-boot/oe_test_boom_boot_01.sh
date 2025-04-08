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
    boom entry show -b 1 
    CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
    boom entry show --boot-id 1
    CHECK_RESULT $? 0 0 "L$LINENO: --boot-id No Pass"
    boom entry show --bootid 1 
    CHECK_RESULT $? 0 0 "L$LINENO: --bootid No Pass"
    boom profile show --boot-dir /boot/ 
    CHECK_RESULT $? 0 0 "L$LINENO: --boot-dir No Pass"
    boom entry show -B /path/to/btrfs/subvolume 
    CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
    boom entry show --btrfs-subvolume /path/to/btrfs/subvolume 
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-subvolume No Pass"
    boom entry show --btrfssubvolume /path/to/btrfs/subvolume 
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfssubvolume No Pass"
    boom profile show --btrfs-opts "boom-opts" 
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-opts No Pass"
    boom profile show --btrfsopts "boom-opts" 
    CHECK_RESULT $? 0 0 "L$LINENO: --btrfsopts No Pass"
    boom profile show -c ./ 
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    boom profile show --config ./ 
    CHECK_RESULT $? 0 0 "L$LINENO: --config No Pass"
    boom profile show --debug "profile" 
    CHECK_RESULT $? 0 0 "L$LINENO: --debug  No Pass"
    boom profile show -H 
    CHECK_RESULT $? 0 0 "L$LINENO: -H No Pass"
    boom entry show -L /dev/openeuler/root 
    CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
    boom entry show --root-lv /dev/openeuler/root 
    CHECK_RESULT $? 0 0 "L$LINENO: --root-lv No Pass"
    boom entry show --rootlv /dev/openeuler/root 
    CHECK_RESULT $? 0 0 "L$LINENO: --rootlv No Pass"
    boom profile show --lvm-opts "profile" 
    CHECK_RESULT $? 0 0 "L$LINENO:  --lvm-opts No Pass"
    boom profile show --lvmopts "profile" 
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
