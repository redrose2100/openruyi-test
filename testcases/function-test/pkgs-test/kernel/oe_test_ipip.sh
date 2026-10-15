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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   Test ipip模块加载、卸载
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    modinfo ipip |grep name
    CHECK_RESULT $? 0 0 "Failed to view module information"
    lsmod | grep ^ipip
    CHECK_RESULT $? 1 0 "Module loaded"
    modprobe ipip
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep ^ipip
    CHECK_RESULT $? 0 0 "Module not loaded"
    rmmod ipip
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep ^ipip
    CHECK_RESULT $? 1 0 "Module loaded"
    LOG_INFO "Finish test!"
}

main "$@"