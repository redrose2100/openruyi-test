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
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2023/08/09
# @License   :   Mulan PSL v2
# @Desc      :   Test dracut-initramfs function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "dracut"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    dracut --force
    CHECK_RESULT $? 0 0 "Create initramfs fail"
    test -f "/boot/initramfs-$(uname -a | awk -F ' ' '{print $3}').img"
    dracut --hostonly --force
    CHECK_RESULT $? 0 0 "Create min initramfs fail"
    lsinitrd "/boot/initramfs-$(uname -a | awk -F ' ' '{print $3}').img" |less
    CHECK_RESULT $? 0 0 "Check initramfs fail"
    lsinitrd "/boot/initramfs-$(uname -a | awk -F ' ' '{print $3}').img" /etc/ld.so.conf | grep "include ld.so.conf.d/\*.conf"
    CHECK_RESULT $? 0 0 "Check ld.so.conf.d/*.conf fail"
    dracut --list-module
    CHECK_RESULT $? 0 0 "Check module fail"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf "/boot/initramfs-$(uname -a | awk -F ' ' '{print $3}').img"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
