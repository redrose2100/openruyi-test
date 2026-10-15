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
# @Date      :   2023-04-03
# @License   :   Mulan PSL v2
# @Desc      :   内核-HQlogic驱动
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test()
{
    LOG_INFO "Start testing..."
    modinfo qla2xxx | grep "name:" | grep "qla2xxx"
    CHECK_RESULT $? 0 0 "qla2xxx drivers not found"
    modpath=$(modinfo qla2xxx | grep "filename:" | awk -F ':' '{print $2}')
    echo $modpath | grep "kernel/drivers/scsi/qla2xxx/qla2xxx.ko"
    CHECK_RESULT $? 0 0 "qla2xxx.ko not exist"

    modprobe qla2xxx
    CHECK_RESULT $? 0 0 "modprobe qla2xxx failed"
    lsmod | grep qla2xxx
    CHECK_RESULT $? 0 0 "lsmod failed"
    modinfo qla2xxx | grep "name:" | grep "qla2xxx"
    CHECK_RESULT $? 0 0 "modinfo qla2xxx failed"

    rmmod qla2xxx
    CHECK_RESULT $? 0 0 "rmmod qla2xxx failed"
    lsmod | grep qla2xxx
    CHECK_RESULT $? 1 0 "qla2xxx info exist"
    modinfo qla2xxx | grep "name:" | grep "qla2xxx"
    CHECK_RESULT $? 0 0 "modinfo qla2xxx failed"

    dmesg | grep "qla2xxx" | grep -Ei 'error|fail'
    CHECK_RESULT $? 1 0 "qla2xxx error info exist"

    LOG_INFO "Finish test!"
}

main $@
