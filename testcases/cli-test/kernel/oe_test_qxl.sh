#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-04-04
# @License   :   Mulan PSL v2
# @Desc      :   内核-驱动-qxl显卡驱动
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test()
{
    LOG_INFO "Start testing..."
    modinfo qxl | grep "name:" | grep "qxl"
    CHECK_RESULT $? 0 0 "qxl drivers not found"

    modprobe qxl
    CHECK_RESULT $? 0 0 "modprobe qxl failed"
    lsmod | grep ^qxl
    CHECK_RESULT $? 0 0 "lsmod failed"

    modprobe -r qxl
    CHECK_RESULT $? 0 0 "unload qxl failed"
    lsmod | grep ^qxl
    CHECK_RESULT $? 1 0 "qxl info exist"
    LOG_INFO "Finish test!"
}

main "$@"
