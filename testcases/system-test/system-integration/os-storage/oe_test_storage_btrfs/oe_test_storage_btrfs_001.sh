#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ####################################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/06
# @License   :   Mulan PSL v2
# @Desc      :   Test btrfs file system identification 
# ####################################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL 'btrfs-progs'
    testdir=/tmp/test
    mountdir=/mnt/test
    mkdir ${testdir} ${mountdir}
    dd if=/dev/zero of=${testdir}/test.img bs=100M count=4
    cd ${testdir}
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    mkfs -t btrfs test.img
    CHECK_RESULT $? 0 0 "Formatting failure"
    mount test.img /mnt/test
    df -hT | grep btrfs
    CHECK_RESULT $? 0 0 "Mount failure"
    touch ${mount}/file
    test -e ${mount}/file
    CHECK_RESULT $? 0 0 "Create failure"
    umount ${mountdir}
    test -e ${mountdir}/file
    CHECK_RESULT $? 0 1 "Umount failure"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${testdir} ${mountdir}
    LOG_INFO "Finish environment cleanup."
}

main $@

