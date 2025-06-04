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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-5-29
# @License   :   Mulan PSL v2
# @Desc      :   command lssubsys
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    lssubsys
    CHECK_RESULT $? 0 0 "Display information of all mounted controllers"
    lssubsys -h
    CHECK_RESULT $? 0 0 "Display  help"
    lssubsys -a | grep cpu
    CHECK_RESULT $? 0 0 "Display information about all controllers (including not mounted ones) "
    lssubsys -i | grep cpuset
    CHECK_RESULT $? 0 0 "Display information about hierarchies"
    lssubsys -m | grep memory 
    CHECK_RESULT $? 0 0 "Display mount points"
    lssubsys -M | grep devices
    CHECK_RESULT $? 0 0 "Display all mount points"
    lssubsys -a -i | grep cpu
    CHECK_RESULT $? 0 0 "Display the hierarchical information of all controllers"
    lssubsys -m -M | grep blkio
    CHECK_RESULT $? 0 0 "Display the mount points of all controllers and the information of all mount points"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
