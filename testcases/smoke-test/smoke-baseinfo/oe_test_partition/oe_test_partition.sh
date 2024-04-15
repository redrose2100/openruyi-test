#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/04/19
# @License   :   Mulan PSL v2
# @Desc      :   View partition information
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    if df -h / | grep overlay; then
        LOG_INFO "The current environment is Docker."
    else
        lsblk | grep "/boot$"
        CHECK_RESULT $? 0 0 "No boot partition"
        lsblk | grep "/$"
        CHECK_RESULT $? 0 0 "No / partition"
	if [ "$(uname -m)" != "riscv64" ]; then
            lsblk | grep "SWAP"
            CHECK_RESULT $? 0 0 "No swap partition"
	fi
    fi
    lsblk --help
    CHECK_RESULT $? 0 0 "lsblk -h info error"
    lsblk -t | grep SCHED
    CHECK_RESULT $? 0 0 "lsblk -t info error"
    lsblk -m | grep MODE
    CHECK_RESULT $? 0 0 "lsblk -m info error"
    lsblk -b | grep "MOUNTPOINT"
    CHECK_RESULT $? 0 0 "lsblk -b info error"
    LOG_INFO "Finish test!"
}

main "$@"
