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
# @Author    :   dengailing
# @Contact   :   dengailing@uniontech.com
# @Date      :   2023-02-16
# @License   :   Mulan PSL v2
# @Desc      :   test hdparm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function run_test() {
    LOG_INFO "Start testing..."
    lsblk >> lsblk.txt
    dev=$(sed -n "2, 1p" lsblk.txt |awk '{print $1}')
    hdparm -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "hdparm -h fail"
    hdparm -a /dev/$dev | grep -i "/dev/sd"
    CHECK_RESULT $? 0 0 "hdparm -a system fail"
    hdparm -b /dev/$dev | grep -i "/dev/sd"
    CHECK_RESULT $? 0 0 "hdparm -b system fail"
    hdparm -c /dev/$dev | grep -i "IO_support"
    CHECK_RESULT $? 0 0 "hdparm -c system fail"
    hdparm -m /dev/$dev | grep -i "multcount"
    CHECK_RESULT $? 0 0 "hdparm -m system fail"
    hdparm -V /dev/$dev | grep -i "hdparm"
    CHECK_RESULT $? 0 0 "hdparm -V system fail"
    hdparm -r /dev/$dev | grep -i "readonly"
    CHECK_RESULT $? 0 0 "hdparm -r system fail"
    hdparm -I /dev/$dev | grep -i "Capabilities"
    CHECK_RESULT $? 0 0 "hdparm -I system fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf lsblk.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
