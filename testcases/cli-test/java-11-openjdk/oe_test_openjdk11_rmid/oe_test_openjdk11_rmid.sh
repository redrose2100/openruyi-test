#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023-08-03
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../common/Hello.java .
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rmic -help | grep "Usage"
    CHECK_RESULT $? 0 0 "rmic  -help failed"
    rmid -port 1111 -log portlog &
    SLEEP_WAIT 3
    rmid -stop -port 1111
    CHECK_RESULT $? 0 0 "rmid -stop -port failed"
    find portlog
    CHECK_RESULT $? 0 0 "not find portlog"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello.* portlog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
