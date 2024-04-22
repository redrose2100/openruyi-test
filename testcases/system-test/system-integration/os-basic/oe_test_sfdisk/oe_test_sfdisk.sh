#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangyiqiao
# @Contact   :   wangyiqiao@uniontech.com
# @Date      :   2024-3-27
# @License   :   Mulan PSL v2
# @Desc      :   Disk partition management tool
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    disk=$(lsblk -o NAME,TYPE | grep disk | awk 'NR==1{print $1}')
    sfdisk -d /dev/"${disk}" | grep "label"
    CHECK_RESULT $? 0 0 "Label not found"
    sfdisk -l | grep "Disk"
    CHECK_RESULT $? 0 0 "Search for 'disk' failed"
    LOG_INFO "Finish test!"
}

main "$@"
