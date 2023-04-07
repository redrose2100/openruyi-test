#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-04-06
#@License       :   Mulan PSL v2
#@Desc          :   Start fapolicydb servive
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fapolicyd"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "inactive" 0 "fapolicyd default status"
    CHECK_RESULT "$(systemctl is-enabled fapolicyd)" "disabled" 0 "fapolicyd default self-start status"

    systemctl enable --now fapolicyd
    CHECK_RESULT $? 0 0 "start fapolicyd"
    CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "active" 0 "fapolicyd status after start"
    CHECK_RESULT "$(systemctl is-enabled fapolicyd)" "enabled" 0 "fapolicyd self-start status after enable"

    systemctl stop fapolicyd
    CHECK_RESULT $? 0 0 "stop fapolicyd"
    CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "inactive" 0 "fapolicyd status after stop"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
