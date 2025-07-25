#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   set parameter config_update_interval test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_config.ini /etc/eagle/eagle_config.ini_bak
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/config_update_interval=.*/config_update_interval=7/' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 80
    grep "Config file has been modified. path: /etc/eagle/eagle_config.ini" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check config_update_interval is dynamic modify failed"

    echo > /var/log/eagle/eagle.log
    sed -i 's/file_size=.*/file_size=3/' /etc/eagle/eagle_config.ini
    SLEEP_WAIT 5
    grep "Config file has been modified. path: /etc/eagle/eagle_config.ini" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check config_update_interval is dynamic modify failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_config.ini_bak /etc/eagle/eagle_config.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
