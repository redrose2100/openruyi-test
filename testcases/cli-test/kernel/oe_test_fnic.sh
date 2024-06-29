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
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2023/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Huawei fnic  module
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    if [ "${NODE1_FRAME}" == "riscv64" ] ; then
        echo "The environment is not support!"
        exit 0
    fi
    kernel_name=$(uname -r)
    kmod_path="/usr/lib/modules/${kernel_name}/kernel/drivers"
    test_mod=scsi/fnic
    mod_name=fnic
    if test -f "${kmod_path}/${test_mod}/${mod_name}.ko.xz"; then
        has_compressed_mod=1
        xz -dk "${kmod_path}"/"${test_mod}"/*
    fi
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/scsi/fnic/fnic.ko
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo fnic |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe fnic
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep fnic
    CHECK_RESULT $? 0 0 "Module loaded failed"
    if [ "$(modprobe --version | grep version | awk '{print $3}')" -gt "29" ]; then
        modprobe -r --remove-holders "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    else
        modprobe -r "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    fi    
    lsmod | grep fnic
    CHECK_RESULT $? 1 0 "Module loaded"
    dmesg |grep fnic
    CHECK_RESULT $? 0 0 "Failed to detect information"
    if test "${has_compressed_mod}" = "1" ; then
        rm -f "${kmod_path}"/"${test_mod}"/*.ko
    fi
}

main "$@"

