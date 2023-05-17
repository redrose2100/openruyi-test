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
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test 驱动加载_snd-aloop
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    modinfo snd-aloop |grep name
    CHECK_RESULT $? 0 0 "Failed to view module information"
    lsmod | grep ^snd_aloop
    CHECK_RESULT $? 1 0 "Module loaded"
    modprobe snd-aloop
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep ^snd_aloop
    CHECK_RESULT $? 0 0 "Module not loaded"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    rmmod snd-aloop
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"