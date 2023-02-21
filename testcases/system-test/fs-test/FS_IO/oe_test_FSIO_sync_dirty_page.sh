#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-04-29
#@License   	:   Mulan PSL v2
#@Desc      	:   Check dirty page writeback after executing sync
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of=/tmp/test_dirty_page_file bs=5120 count=1
    dirty1=$(grep Dirty /proc/meminfo | awk '{print $2}')
    sync
    dirty2=$(grep Dirty /proc/meminfo | awk '{print $2}')
    [[ $dirty1 -gt $dirty2 ]]
    CHECK_RESULT $? 0 0 "The dirty page doesn't writeback after executing sync."
    LOG_INFO "End to run test."
}

main "$@"

