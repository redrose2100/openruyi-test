#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    hdparm -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "hdparm -h fail"
    hdparm -a /dev/sd* | grep -i "/dev/sd"
    CHECK_RESULT $? 0 0 "hdparm -a system fail"
    hdparm -b /dev/sd* | grep -i "/dev/sd"
    CHECK_RESULT $? 0 0 "hdparm -b system fail"
    hdparm -c /dev/sd* | grep -i "IO_support"
    CHECK_RESULT $? 0 0 "hdparm -c system fail"
    hdparm -m /dev/sd* | grep -i "multcount"
    CHECK_RESULT $? 0 0 "hdparm -m system fail"
    hdparm -V /dev/sd* | grep -i "hdparm"
    CHECK_RESULT $? 0 0 "hdparm -V system fail"
    hdparm -r /dev/sd* | grep -i "readonly"
    CHECK_RESULT $? 0 0 "hdparm -r system fail"
    hdparm -I /dev/sd* | grep -i "Capabilities"
    CHECK_RESULT $? 0 0 "hdparm -I system fail"
    LOG_INFO "Finish test!"
}

main "$@"
