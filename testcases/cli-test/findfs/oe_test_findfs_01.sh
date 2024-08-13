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
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2024-7-31
# @License   :   Mulan PSL v2
# @Desc      :   Test command findfs
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    ROOT_UUID=$(blkid |grep root |awk -F " " '{print $2}'|awk -F "=" '{print $2}'|tr -d '""')
    ROOT_DEV=$(blkid |grep root |awk -F " " '{print $1}'|tr -d ':')    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    findfs UUID="$ROOT_UUID"| grep "$ROOT_DEV"
    CHECK_RESULT $? 0 0 "cannot find $ROOT_DEV in system."
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"