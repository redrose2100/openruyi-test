#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   dengailing
# @Contact   :   dengailing@uniontech.com
# @Date      :   2023-01-12
# @License   :   Mulan PSL v2
# @Desc      :   test dmidecode
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dmidecode
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    dmidecode -h | grep -i "Usage: dmidecode"
    CHECK_RESULT $? 0 0 "dmidecode -h fail"
    dmidecode -t system | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point"
    CHECK_RESULT $? 0 0 "dmidecode -t system fail"
    dmidecode -t bios | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t bios fail"
    dmidecode -t baseboard | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t baseboard fail"
    dmidecode -t chassis | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t chassis fail"
    dmidecode -t processor | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t processor fail"
    dmidecode -t memory | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t memory fail"
    dmidecode -t cache | grep -E "Getting SMBIOS data from sysfs|Found SMBIOS entry point in EFI"
    CHECK_RESULT $? 0 0 "dmidecode -t cache fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
