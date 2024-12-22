#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-09-10
# @License   :   Mulan PSL v2
# @Desc      :   dm-event.service restart test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8   
    DNF_INSTALL "device-mapper-event" 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start dm-event
    systemctl status dm-event.service |grep -w "active"
    CHECK_RESULT $? 0 0 "dm-event service status failed"
    systemctl stop dm-event
    systemctl status dm-event.service |grep "inactive"
    CHECK_RESULT $? 0 0 "stop dm-event service failed"
    systemctl restart dm-event
    systemctl status dm-event.service |grep "active"
    CHECK_RESULT $? 0 0 "restart  dm-event service failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    systemctl stop dm-event
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"


