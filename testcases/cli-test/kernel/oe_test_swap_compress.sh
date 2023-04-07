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
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test 内核-swap压缩
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    default_swap=`free -lh |grep -i swap |awk '{print $2}' |awk -F"G" '{print $1}'`
    swapoff /dev/dm-1
    swap1=`free -lh |grep -i swap |awk '{print $2}' |awk -F"B" '{print $1}'`
    CHECK_RESULT $swap1 0 0 "Uninstall Failed"
    lvreduce -L -1G -f /dev/openeuler/swap
    mkswap /dev/openeuler/swap
    CHECK_RESULT $? 0 0 "Erase failed"
    swapon /dev/openeuler/swap
    swap2=`free -lh |grep -i swap |awk '{print $2}' |awk -F"G" '{print $1}'`
    [ `echo "${default_swap} > ${swap2}" |bc` -eq 1 ]
    CHECK_RESULT $? 0 0 "Compression failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    swapoff /dev/dm-1
    lvextend -L +1G -f /dev/openeuler/swap
    mkswap /dev/openeuler/swap
    swapon /dev/openeuler/swap
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"