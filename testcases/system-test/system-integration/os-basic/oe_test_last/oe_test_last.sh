#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   suncui
# @Contact   :   suncui@uniontech.com
# @Date      :   2024-03-26
# @License   :   Mulan PSL v2
# @Desc      :   test last
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    last |grep -i wtmp
    CHECK_RESULT $? 0 0 "default option result fail"
    lastb -n 2
    CHECK_RESULT $? 0 0 "-n option result fail"
    last --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "last --help execute fail"
    last --version | grep -i last
    CHECK_RESULT $? 0 0 "last --version execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
