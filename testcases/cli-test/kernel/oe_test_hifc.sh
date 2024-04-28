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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023/07/03
# @License   :   Mulan PSL v2
# @Desc      :   Huawei HIFC added to the kernel_ HBA card driver
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    modinfo hifc | grep name
    CHECK_RESULT $? 0 0 "Module hifc not found"
    modinfo hifc | grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe hifc
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep ^hifc
    CHECK_RESULT $? 0 0 "Module loaded failed"
    modprobe -r hifc
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep ^hifc
    CHECK_RESULT $? 1 0 "Module uninstall failed"
    dmesg |grep hifc
    CHECK_RESULT $? 0 0 "Failed to detect information"
}

main "$@"

