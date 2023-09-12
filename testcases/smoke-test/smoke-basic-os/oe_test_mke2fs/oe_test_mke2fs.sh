#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.7.20
# @License   :   Mulan PSL v2
# @Desc      :   mke2fs formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "e2fsprogs"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep e2fsprogs
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && dd if=/dev/zero of=/tmp/100k bs=1k count=100
    mke2fs -I 128 /tmp/100k
    file /tmp/100k > /tmp/100k_test1
    grep "ext2 filesystem data" /tmp/100k_test1
    CHECK_RESULT $? 0 0 "compile 100k_test1 fail"    
    mkdir /opt/test
    mount /tmp/100k /opt/test
    df -h | grep /opt/test > /tmp/100k_test2
    grep "/dev/loop0" /tmp/100k_test2
    CHECK_RESULT $? 0 0 "compile 100k_test2 error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /opt/test
    rm -rf /tmp/100k /tmp/100k_test1 /tmp/100k_test2
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
