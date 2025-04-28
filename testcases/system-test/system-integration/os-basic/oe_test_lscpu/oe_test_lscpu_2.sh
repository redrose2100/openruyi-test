#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2024-4-23
# @License   :   Mulan PSL v2
# @Desc      :   command lscpu 
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lscpu -b -p | grep -A 2 CPU
    CHECK_RESULT $? 0 0 "only print online cpus fail"
    lscpu -c -p | grep -A 2 CPU
    CHECK_RESULT $? 0 0 "only print offline cpu fail"
    lscpu -B | grep L
    CHECK_RESULT $? 0 0 "print sizes in bytes fail"
    if [ "${NODE1_FRAME}" != "riscv64" ];then
        lscpu -C | grep L
        CHECK_RESULT $? 0 0 "show info about caches fail"
    fi
    lscpu -J | grep field
    CHECK_RESULT $? 0 0 "show info using JSON for default fail"
    lscpu -x | grep CPU
    CHECK_RESULT $? 0 0 "print the hexadecimal mask fail"
    lscpu -y | grep CPU
    CHECK_RESULT $? 0 0 "print physical ID fail"
    LOG_INFO "End to run test."
}

main "$@"
