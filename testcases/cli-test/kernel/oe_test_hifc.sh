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
    kernel_name=$(uname -r)
    kmod_path="/usr/lib/modules/${kernel_name}/kernel/drivers"
    test_mod=scsi/huawei/hifc
    mod_name=hifc
    if test -f "${kmod_path}/${test_mod}/${mod_name}.ko.xz"; then
        has_compressed_mod=1
        xz -dk "${kmod_path}"/"${test_mod}"/*
    fi
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/scsi/huawei/hifc/hifc.ko
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo hifc |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe hifc
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep hifc
    CHECK_RESULT $? 0 0 "Module loaded failed"
    if [ "$(modprobe --version | grep version | awk '{print $3}')" -gt "29" ]; then
        modprobe -r --remove-holders "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    else
        modprobe -r "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    fi    
    lsmod | grep hifc
    CHECK_RESULT $? 1 0 "Module loaded"
    dmesg |grep hifc
    CHECK_RESULT $? 0 0 "Failed to detect information"
    if test "${has_compressed_mod}" = "1" ; then
        rm -f "${kmod_path}"/"${test_mod}"/*.ko
    fi
}

main "$@"