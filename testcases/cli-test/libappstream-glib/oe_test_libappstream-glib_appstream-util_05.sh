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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libappstream-glib command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libappstream-glib
    cp -r ./common ./glibtest
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    appstream-util -v --profile --nonet validate-strict glibtest/dejavu.metainfo.xml 2>&1 | grep "appstream-util: validate-strict"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate-strict failed"

    appstream-util -v --profile --nonet vercmp 1.0 2.0 | grep "1.0 < 2.0"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet vercmp failed"

    nohup appstream-util -v --profile --nonet watch glibtest/dejavu.metainfo.xml >glibtest/info2.log 2>&1 &
    SLEEP_WAIT  2
    grep "appstream-util: watch" glibtest/info2.log
    CHECK_RESULT $? 0 0 "Check nohup appstream-util -v --profile --nonet watch failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    ps -ef | grep "appstream-util -v --profile --nonet watch dejavu.metainfo.xml" | grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf glibtest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
