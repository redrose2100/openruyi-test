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


function run_test() {
    LOG_INFO "Start testing..."
    dmidecode -h | grep -i "Usage: dmidecode"
    CHECK_RESULT $? 0 0 "dmidecode -h fail"
    dmidecode -t system | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t system fail"
    dmidecode -t bios | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t bios fail"
    dmidecode -t baseboard | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t baseboard fail"
    dmidecode -t chassis | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t chassis fail"
    dmidecode -t processor | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t processor fail"
    dmidecode -t memory | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t memory fail"
    dmidecode -t cache | grep -i "Getting SMBIOS data from sysfs"
    CHECK_RESULT $? 0 0 "dmidecode -t cache fail"
    LOG_INFO "Finish test!"
}

main "$@"
