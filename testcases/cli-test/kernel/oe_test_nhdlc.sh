#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2025/03/28
# @License   :   Mulan PSL v2
# @Desc      :   Huawei n_hdlc.ko module
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/tty/n_hdlc.ko.xz*
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo n_hdlc |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe n_hdlc
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep n_hdlc
    CHECK_RESULT $? 0 0 "Module loaded failed"
    rmmod n_hdlc
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep n_hdlc
    CHECK_RESULT $? 1 0 "Module loaded"
}

main "$@"

