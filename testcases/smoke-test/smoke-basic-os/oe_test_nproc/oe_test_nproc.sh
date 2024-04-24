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
# @Author    :   chenjiamei
# @Contact   :   chenjiamei@uniontech.com
# @Date      :   2024-04-07
# @License   :   Mulan PSL v2
# @Desc      :   test nproc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    nproc
    CHECK_RESULT $? 0 0 "nproc execute fail"
    nproc --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "nproc --help execute fail"
    nproc --version | grep -i nproc
    CHECK_RESULT $? 0 0 "nproc --version execute fail"
    cpuinfo_count=$(nproc --all)
    cpuinfo_actual=$(grep -c processor /proc/cpuinfo)
    if [ $cpuinfo_count == $cpuinfo_actual ]
    then
      CHECK_RESULT $?
    else
      CHECK_RESULT $?
    fi
    LOG_INFO "Finish test!"
}

main "$@"