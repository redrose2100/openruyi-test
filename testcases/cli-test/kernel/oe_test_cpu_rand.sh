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
# @Desc      :   test CPU是否具有随机数生成功能
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    lscpu | grep rand
    CHECK_RESULT $? 0 0 "The random number generation function is not supported"
    grep ARCH_RANDOM=y /boot/config-$(uname -r)
    CHECK_RESULT $? 0 0 "The random number generation function is not supported"
    grep -w rng /proc/crypto
    CHECK_RESULT $? 0 0 "The random number generation function is not supported"
    LOG_INFO "Finish test!"
}

main "$@"