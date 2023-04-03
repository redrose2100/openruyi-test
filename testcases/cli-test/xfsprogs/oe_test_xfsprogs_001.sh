#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #######################################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test xfsprogs installation and use 
# #######################################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL xfsprogs
    mkdir /tmp/test
    mkdir /mnt/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of=/tmp/test/test.img count=20 bs=1M
    CHECK_RESULT $? 0 0 " Create fail"
    mkfs.xfs /tmp/test/test.img
    CHECK_RESULT $? 0 0 "Format fail"
    mount /tmp/test/test.img /mnt/test
    touch /mnt/test/test.txt
    test -e /mnt/test/test.txt
    CHECK_RESULT $? 0 0 "Create fail2"
    df -hT /mnt/test |grep xfs
    CHECK_RESULT $? 0 0 "Formatting error"
    umount /mnt/test
    test -e /mnt/test/test.txt
    CHECK_RESULT $? 0 1 "Mount failure"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test /mnt/test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

