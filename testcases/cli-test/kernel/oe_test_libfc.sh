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
# @Date      :   2023/07/17
# @License   :   Mulan PSL v2
# @Desc      :   libfc module test
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/scsi/libfc/libfc.ko*
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo libfc |grep -i vermagic
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe libfc
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep libfc
    CHECK_RESULT $? 0 0 "Module loaded failed"
    rmmod libfc
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep libfc
    CHECK_RESULT $? 1 0 "Module loaded"
}

main "$@"

