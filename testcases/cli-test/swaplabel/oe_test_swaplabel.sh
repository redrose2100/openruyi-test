#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024/09/19
# @License   :   Mulan PSL v2
# @Desc      :   Change partition label
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    swap=$(blkid | grep swap |awk -F":" '{print $1}')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    swaplabel "$swap" |grep "LABEL: SWAP"
    CHECK_RESULT $? 0 0 "Failed to display the label of SWAP partition"
    swapoff "$swap"
    swaplabel -L SWAP1 "$swap"
    uuid=$(uuidgen)
    swaplabel -U "$uuid" "$swap"
    CHECK_RESULT $? 0 0 "Failed to modify the label information of SWAP partition to SWAP1"
    swapon "$swap"
    swaplabel "$swap" |grep "LABEL: SWAP1"
    CHECK_RESULT $? 0 0 "SWAP1 failed to filter label information for SWAP partition"
    uuid1=$(swaplabel "$swap" |grep "UUID" |awk '{print $2}')
    [ "$uuid" == "$uuid1" ]
    CHECK_RESULT $? 0 0 "The uuid information of SWAP partition is the same before and after resetting"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    swaplabel -L SWAP "$swap"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
