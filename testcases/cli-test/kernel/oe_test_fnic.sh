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
    kernel_name=$(uname -r)
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/scsi/fnic/fnic.ko.xz
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo fnic |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe fnic
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep fnic
    CHECK_RESULT $? 0 0 "Module loaded failed"
    rmmod fnic
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep fnic
    CHECK_RESULT $? 1 0 "Module loaded"
    dmesg |grep fnic
    CHECK_RESULT $? 0 0 "Failed to detect information"
}

main "$@"

