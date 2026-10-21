#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hujian
# @Contact   :   14201718+hujian52@user.noreply.gitee.com
# @Date      :   2024-3-28
# @License   :   Mulan PSL v2
# @Desc      :   command lscpu
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lscpu | grep CPU 
    CHECK_RESULT $? 0 0 "shou cpu info fail"
    lscpu -V | grep lscpu
    CHECK_RESULT $? 0 0 "show version fail"
    lscpu -e | grep -A 2 CPU
    CHECK_RESULT $? 0 0 "print extension fail"
    lscpu -e=CPU | grep -A 2 CPU
    CHECK_RESULT $? 0 0 "show info about a specified CPU column fail"
    lscpu -e=CORE | grep -A 2 CORE
    CHECK_RESULT $? 0 0 "show number of logical cores fail"
    lscpu -e=NODE | grep -A 2 NODE
    CHECK_RESULT $? 0 0 "show logical NUMA node number fail"
    lscpu -e=ADDRESS | grep -A 2 ADDRESS
    CHECK_RESULT $? 0 0 "show CPU physical addres fail"
    lscpu -e=MAXMHZ | grep -A 2 MAXMHZ 
    CHECK_RESULT $? 0 0 "show maximum CPU frequency fail"
    lscpu -a -e | grep -A 2 CPU
    CHECK_RESULT $? 0 0 "print both online and offline cpus fail"
    LOG_INFO "End to run test."
}

main "$@"
