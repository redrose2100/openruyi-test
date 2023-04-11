#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-4-11
# @License   :   Mulan PSL v2
# @Desc      :   ACL default kernel setting
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    grep -i acl /boot/config-$(uname -r) | grep -i CONFIG_XFS_POSIX_ACL=y         
    CHECK_RESULT $? 0 0 "ACL kernel parameter of xfs file system is not enabled" 
    grep -i acl /boot/config-$(uname -r) |  grep -i CONFIG_EXT4_FS_POSIX_ACL=y
    CHECK_RESULT $? 0 0 "ACL kernel parameter of ext4 file system is not enabled" 
    grep -i acl /boot/config-$(uname -r) | grep -i '=n'
    CHECK_RESULT $? 0 1 "ACL kernel default parm setting is incorrect"   
    LOG_INFO "End to run test."
}

main "$@"

